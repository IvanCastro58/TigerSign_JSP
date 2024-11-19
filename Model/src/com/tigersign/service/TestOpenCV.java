package com.tigersign.service;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Size;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.MatOfByte;
import org.apache.commons.codec.binary.Base64;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;

public class TestOpenCV {
    public static double compareImages(String base64Image1, String base64Image2) {
        try {
            // Load the OpenCV library
            System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
            System.out.println("OpenCV Library Loaded Successfully");
            System.out.println("Java Library Path: " + System.getProperty("java.library.path"));

            // Decode the base64 strings into byte arrays
            byte[] imageBytes1 = Base64.decodeBase64(base64Image1);
            byte[] imageBytes2 = Base64.decodeBase64(base64Image2);

            // Convert the byte arrays into OpenCV Mat objects
            Mat image1 = Imgcodecs.imdecode(new MatOfByte(imageBytes1), Imgcodecs.IMREAD_COLOR);
            Mat image2 = Imgcodecs.imdecode(new MatOfByte(imageBytes2), Imgcodecs.IMREAD_COLOR);

            // Check if both images are loaded successfully
            if (image1.empty() || image2.empty()) {
                System.out.println("Failed to load one or both images.");
                return 0.0;
            }

            // Resize both images to the same size for comparison
            Size size = new Size(300, 300); // Resize to a fixed size
            Imgproc.resize(image1, image1, size);
            Imgproc.resize(image2, image2, size);

            // Convert both images to grayscale
            Mat gray1 = new Mat();
            Mat gray2 = new Mat();
            Imgproc.cvtColor(image1, gray1, Imgproc.COLOR_BGR2GRAY);
            Imgproc.cvtColor(image2, gray2, Imgproc.COLOR_BGR2GRAY);

            // Calculate similarity percentage
            return calculateSimilarity(gray1, gray2);

        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    /**
     * Calculate the similarity percentage between two grayscale images.
     *
     * @param mat1 First image (grayscale Mat).
     * @param mat2 Second image (grayscale Mat).
     * @return Similarity percentage (0-100%).
     */
    public static double calculateSimilarity(Mat mat1, Mat mat2) {
        // Ensure both images have the same size
        if (mat1.size().equals(mat2.size())) {
            // Compute absolute difference
            Mat diff = new Mat();
            Core.absdiff(mat1, mat2, diff);

            // Count non-zero (different) pixels
            Mat diffBinary = new Mat();
            Imgproc.threshold(diff, diffBinary, 50, 255, Imgproc.THRESH_BINARY);

            int totalPixels = (int) (diffBinary.total());
            int nonZeroPixels = Core.countNonZero(diffBinary);

            // Calculate percentage of similarity
            return 100.0 * (totalPixels - nonZeroPixels) / totalPixels;
        } else {
            System.err.println("Images must be of the same size to compare.");
            return 0.0;
        }
    }
}
