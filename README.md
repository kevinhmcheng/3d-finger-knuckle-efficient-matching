# 3d-finger-knuckle-efficient-matching
This folder provides sample data and codes for feature extration, key points detection and matching described in [1]. Please run 'main.m' to start the program.
The details on the 3D finger knuckle images database can also be observed in [2].

Data:
Two subjects, each with two surface normal images, resulted in four surface normal images.

Feature Extraction:
Reads from the surface normal images and produces the feature images (2 binary images for each surface normal image)
Detect the surface key points for further matching.

Matching:
Reads from the feature images and produces the similarity score for each pair of feature images.

References:

[1] Kevin H. M. Cheng, Ajay Kumar. Efficient and Accurate 3D Finger Knuckle Matching using Surface Key Points. IEEE Transactions on Image Processing, 29, pp.8903-8915, 2020.

[2] Kevin H. M. Cheng, Ajay Kumar. Contactless Biometric Identiﬁcation Using 3D Finger Knuckle Patterns. IEEE Transactions on Pattern Analysis and Machine Intelligence, 42(8), pp.1868-1883, 2020.
