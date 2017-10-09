Summary:

A GUI based application for segmenting prostrate and its regions from CT
(Computed Tomography) was developed in this lab work, using MATLAB.
The application expects CT slices encapsulated as DICOM files and allows
the user to view several DICOM headers, anonymize the DICOM files in bulk
by removing information in 2 tags, PatientName and PatientBirthDate, and
convert DICOM images to JPEG as well as allowing conversion the other
way.

The key feature is a semi-automatic segmentation system whereby the
user can annotate the boundaries of a region of prostrate in one slice and
the application propagates this annotation into specified preceding as well as
proceeding slices and constructs a 3D isosurface representation, along with
computing cross-sectional area and volume information. It is also possible
to assign tags to annotations and save them.

To launch the application, open 'ui_for_dicom_ghimire.m'
I recommend that you create your project directory like the following :

	Project Directory:
			- Code
			- Data
			

