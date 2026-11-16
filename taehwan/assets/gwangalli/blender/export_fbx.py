"""Export only the saved bridge collection without touching the live session."""
import json
from pathlib import Path

import bpy

out = Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(out / "gwangan_bridge_blockout.blend"))
collection = bpy.data.collections["GwanganBridge_Blockout"]
scene = next(s for s in bpy.data.scenes if collection in tuple(s.collection.children))
bpy.context.window.scene = scene
bpy.ops.object.select_all(action="DESELECT")
objects = [obj for obj in collection.all_objects if obj.type == "MESH"]
for obj in objects:
    obj.select_set(True)
bpy.context.view_layer.objects.active = objects[0]
target = out / "gwangan_bridge_blockout.fbx"
bpy.ops.export_scene.fbx(
    filepath=str(target),
    use_selection=True,
    object_types={"MESH"},
    axis_forward="-Z",
    axis_up="Y",
    apply_unit_scale=True,
    apply_scale_options="FBX_SCALE_UNITS",
    use_mesh_modifiers=True,
    bake_anim=False,
    path_mode="COPY",
    embed_textures=True,
)
print("FBX_EXPORT_COMPLETE", json.dumps({
    "path": str(target), "bytes": target.stat().st_size,
    "mesh_count": len(objects), "names": [obj.name for obj in objects],
}))
