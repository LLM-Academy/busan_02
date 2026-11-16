"""Render the saved blockout without changing the source blend file."""
import bpy
import math
from pathlib import Path
from mathutils import Vector

out = Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(out / "gwangan_bridge_blockout.blend"))
scene = bpy.data.scenes["GwanganBridge_Blockout"]
bpy.context.window.scene = scene
scene.render.engine = "CYCLES"
scene.cycles.samples = 16
scene.render.resolution_x = 1440
scene.render.resolution_y = 720
scene.render.resolution_percentage = 100
scene.render.image_settings.file_format = "PNG"
scene.render.filepath = str(out / "bridge_preview.png")
scene.world = bpy.data.worlds.new("PreviewWorld")
scene.world.use_nodes = True
scene.world.node_tree.nodes["Background"].inputs[0].default_value = (0.12, 0.16, 0.23, 1)
scene.world.node_tree.nodes["Background"].inputs[1].default_value = 0.6

camera_data = bpy.data.cameras.new("PreviewCamera")
camera = bpy.data.objects.new("PreviewCamera", camera_data)
scene.collection.objects.link(camera)
camera.location = (105, -270, 110)
camera.rotation_euler = (Vector((0, 0, 17)) - camera.location).to_track_quat("-Z", "Y").to_euler()
camera_data.type = "ORTHO"
camera_data.ortho_scale = 345
scene.camera = camera

sun_data = bpy.data.lights.new("PreviewSun", "SUN")
sun_data.energy = 3
sun_data.angle = math.radians(20)
sun = bpy.data.objects.new("PreviewSun", sun_data)
scene.collection.objects.link(sun)
sun.rotation_euler = (math.radians(25), math.radians(-30), math.radians(-20))
bpy.ops.render.render(write_still=True)
