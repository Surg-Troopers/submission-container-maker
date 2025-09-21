# extract frame from input video from GrandChallenge
import cv2
import os

def extract_frames(video_path, output_dir, fps=1):
    """
    Extract frames from a video at specified FPS.

    Args:
        video_path (str): Path to the video file.
        output_dir (str): Directory to save extracted frames.
        fps (int): Number of frames to extract per second.
    """
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Open the video
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise ValueError(f"Cannot open video: {video_path}")

    video_fps = cap.get(cv2.CAP_PROP_FPS)  # original video FPS
    frame_interval = int(video_fps / fps)  # interval between frames to grab

    count = 0
    saved_count = 1
    while True:
        ret, frame = cap.read()
        if not ret:
            break  # end of video

        if count % frame_interval == 0:
            # Save frame
            frame_name = os.path.join(output_dir, f"frame_{saved_count:05d}.jpg")
            cv2.imwrite(frame_name, frame)
            saved_count += 1

        count += 1

    cap.release()
    print(f"Extracted {saved_count} frames to {output_dir}")