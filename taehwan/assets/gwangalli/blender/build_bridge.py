"""Generate a reviewable bridge blockout, not a surveyed replica.

Run: blender --background --python build_bridge.py
Outputs stay alongside this script. Does not touch an open Blender session.
Dimensions below are proposed game dimensions in studs, not real bridge data.
"""
import bpy
import json
import math
from pathlib import Path
from mathutils import Vector

OUT = Path(__file__).resolve().parent
STUD_METRES = 0.28
COLLECTION = "GwanganBridge_Blockout"


def material(name, colour, metal=0.0):
    mat = bpy.data.materials.new(name)
    mat.diffuse_color = (*colour, 1)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*colour, 1)
    bsdf.inputs["Metallic"].default_value = metal
    bsdf.inputs["Roughness"].default_value = 0.55
    return mat


def move_to_collection(obj):
    for old in list(obj.users_collection):
        old.objects.unlink(obj)
    group.objects.link(obj)


def box(name, location, dimensions, mat):
    bpy.ops.mesh.primitive_cube_add(size=1, location=location)
    obj = bpy.context.object
    obj.name = name
    obj.dimensions = dimensions
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    move_to_collection(obj)
    return obj


def rod(name, a, b, radius, mat):
    a, b = Vector(a), Vector(b)
    delta = b - a
    bpy.ops.mesh.primitive_cylinder_add(
        vertices=8, radius=radius, depth=delta.length, location=(a + b) / 2
    )
    obj = bpy.context.object
    obj.name = name
    obj.rotation_euler = delta.to_track_quat("Z", "Y").to_euler()
    obj.data.materials.append(mat)
    move_to_collection(obj)
    return obj


# A separate scene keeps any existing scene objects unchanged if run interactively.
scene = bpy.data.scenes.new(COLLECTION)
bpy.context.window.scene = scene
scene.unit_settings.system = "METRIC"
scene.unit_settings.scale_length = 1.0
group = bpy.data.collections.new(COLLECTION)
scene.collection.children.link(group)
steel = material("BridgeSteel_Linear", (0.48, 0.53, 0.58), 0.35)
deck = material("DeckConcrete_Linear", (0.17, 0.19, 0.22))
guide = material("OrientationMarker_Linear", (0.8, 0.12, 0.03))

# Blender axes: X along bridge, Z up. Source +Y maps to Roblox -Z.
box("LowerDeck", (0, 0, 32), (1100, 28, 3), deck)
box("UpperDeck", (0, 0, 43), (1100, 28, 3), deck)
for x in (-270, 270):
    for y in (-19, 19):
        box(f"TowerLeg_{x}_{y}", (x, y, 70), (9, 9, 140), steel)
    for z in (28, 62, 128):
        box(f"TowerCrossbeam_{x}_{z}", (x, 0, z), (10, 47, 7), steel)


def cable_height(x):
    if -270 <= x <= 270:
        return 72 + 66 * (x / 270) ** 2
    return 48 + 90 * ((550 - abs(x)) / 280) ** 2


# Join cables into groups for fewer mesh objects without losing editability
# of towers/decks. Curves below are temporary proportions pending photos.
for y in (-19, 19):
    cables = []
    points = [-550 + i * 1100 / 88 for i in range(89)]
    points = sorted(set(points + [-270, 270]))
    for i, (x0, x1) in enumerate(zip(points, points[1:])):
        cables.append(rod(f"Cable_{y}_{i}",
                          (x0, y, cable_height(x0)),
                          (x1, y, cable_height(x1)), 0.8, steel))
    for x in range(-525, 526, 25):
        cables.append(rod(f"Hanger_{y}_{x}", (x, y, 45),
                          (x, y, cable_height(x)), 0.32, steel))
    bpy.ops.object.select_all(action="DESELECT")
    for obj in cables:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = cables[0]
    bpy.ops.object.join()
    cables[0].name = f"Cables_{'PositiveY' if y > 0 else 'NegativeY'}"

# Deliberate asymmetric, removable marker for import orientation verification.
box("REMOVE_AFTER_IMPORT_Orientation_PosX_PosY", (535, 24, 48), (8, 8, 8), guide)

for obj in group.objects:
    obj.location *= STUD_METRES
    obj.scale *= STUD_METRES
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)

objects = list(group.objects)
all_vertices = [obj.matrix_world @ v.co for obj in objects for v in obj.data.vertices]
mins = [min(v[i] for v in all_vertices) for i in range(3)]
maxs = [max(v[i] for v in all_vertices) for i in range(3)]
report = {
    "status": "PROTOTYPE_NOT_SURVEYED",
    "reference_status": "No verified Google Maps or Street View imagery available",
    "expected_size_studs_xyz_blender": [(b-a)/STUD_METRES for a,b in zip(mins,maxs)],
    "source_size_metres_xyz": [b-a for a,b in zip(mins,maxs)],
    "orientation": "Bridge along X; Blender +Z up; orange marker at +X,+Y",
    "meshes": [],
}
for obj in objects:
    obj.data.calc_loop_triangles()
    report["meshes"].append({
        "name": obj.name,
        "triangles": len(obj.data.loop_triangles),
        "material": obj.data.materials[0].name,
        "linear_rgba": list(obj.data.materials[0].diffuse_color),
    })

OUT.mkdir(parents=True, exist_ok=True)
(OUT / "bridge_manifest.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
bpy.ops.wm.save_as_mainfile(filepath=str(OUT / "gwangan_bridge_blockout.blend"))
bpy.ops.object.select_all(action="DESELECT")
for obj in objects:
    obj.select_set(True)
bpy.ops.export_scene.gltf(
    filepath=str(OUT / "gwangan_bridge_blockout.glb"),
    export_format="GLB", use_selection=True, export_yup=True,
)
print("GWANGAN_EXPORT_COMPLETE", json.dumps(report))
