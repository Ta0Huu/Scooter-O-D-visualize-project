import math

def latlon_to_pixel(lon, lat, z, tile_size=256):
    x = (lon + 180.0) / 360.0
    sin_lat = math.sin(math.radians(lat))
    y = 0.5 - math.log((1 + sin_lat) / (1 - sin_lat)) / (4 * math.pi)
    scale = tile_size * (2**z)
    return x * scale, y * scale

def pixel_to_latlon(px, py, z, tile_size=256):
    scale = tile_size * (2**z)
    x = px / scale
    y = py / scale
    lon = x * 360.0 - 180.0
    n = math.pi - 2.0 * math.pi * y
    lat = math.degrees(math.atan(math.sinh(n)))
    return lon, lat

# ใส่ค่าจาก URL ของคุณ
center_lon = -114.09567245
center_lat = 51.0192767
zoom = 11.2
width = 1200
height = 900

cx, cy = latlon_to_pixel(center_lon, center_lat, zoom)
half_w, half_h = width/2.0, height/2.0

left_px  = cx - half_w
right_px = cx + half_w
top_py   = cy - half_h
bottom_py= cy + half_h

mapGeoLeft, mapGeoTop    = pixel_to_latlon(left_px, top_py, zoom)
mapGeoRight, mapGeoBottom= pixel_to_latlon(right_px, bottom_py, zoom)

print(mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom)
