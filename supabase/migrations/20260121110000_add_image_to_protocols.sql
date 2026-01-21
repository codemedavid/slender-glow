-- Add image_url to protocols table
ALTER TABLE protocols
ADD COLUMN IF NOT EXISTS image_url TEXT;
