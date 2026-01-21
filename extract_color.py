from PIL import Image
from collections import Counter

def get_dominant_color(image_path):
    try:
        img = Image.open(image_path)
        img = img.convert("RGB")
        img = img.resize((50, 50))  # Resize to speed up
        pixels = list(img.getdata())
        
        # Filter out white/near-white pixels if any, as they might be background
        filtered_pixels = [p for p in pixels if not (p[0] > 240 and p[1] > 240 and p[2] > 240)]
        
        if not filtered_pixels:
            filtered_pixels = pixels

        counts = Counter(filtered_pixels)
        most_common = counts.most_common(1)[0][0]
        
        hex_color = '#{:02x}{:02x}{:02x}'.format(most_common[0], most_common[1], most_common[2])
        print(f"Dominant Color: {hex_color}")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    get_dominant_color("/Users/ynadonaire/.gemini/antigravity/brain/f09ec417-d471-41cc-980b-381786e413b6/uploaded_image_1_1768930148164.png")
