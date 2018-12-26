public class Hosp_DoctorProfileImageController {
    Public Transient blob propFileBody { get; set; }
    Public Transient string propFileName { get; set; }
    Public Transient string propContentType { get; set; }
    Public Integer fileSize { get; set; }
    public Boolean doneUploading { get; set; }
    public Boolean doneUploadingCroping { get; set; }
    public Boolean uploadCroping { get; set; }
    public Transient String uplDocUrl { get; set; }
    public Transient String inputDataUrl { get; set; }

    public String documentId { get; set; }
    public String recordId { get; set; }
    public String firstLastName { get; set; }

    public Hosp_DoctorProfileImageController() {
        recordId = ApexPages.currentPage().getParameters().get('recordId');

        generateFirstLastName();

        try {
            uplDocUrl = '';
            inputDataUrl = '';
            uploadCroping = false;
            doneUploading = false;
            doneUploadingCroping = false;
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString());
            ApexPages.addMessage(msg);
        }
    }

    public PageReference uploadPicture() {
        try {
            Transient User UserContactId;
            if (! uploadCroping ) {
                return EditProfilePic();
            } else {
                return uploadCrop();
            }
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public PageReference EditProfilePic() {
        try {
            //System.debug('@@@@# propFileBody' + propFileBody + '' + propFileName + '' + propContentType + 'fileSize' + fileSize + 'propFileName' + propFileName);

            // checking file size should be less then 5 MB
            if (fileSize > 2097152) {
                List<String> messageComponents = new List<String>{};

                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Image_too_large, new List<String>{propFileName}));
                ApexPages.addMessage(msg);
            } else if ((propContentType != 'image/png') && (propContentType != 'image/jpeg')) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Image_invalid_type);
                ApexPages.addMessage(msg);
            } else {
                String strtemp = EncodingUtil.base64Encode(propFileBody);
                if (!String.isblank(strtemp)) {
                    uplDocUrl = 'data:' + propContentType + ';base64,' + strtemp;    // set the image url to display image on the page
                } else {
                    uplDocUrl = '';
                }
                doneUploading = true;
            }
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Message, new List<String>{ex.getStackTraceString(), ex.getMessage()}));
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public Pagereference uploadCrop() {
        List<String> datalist = inputDataUrl.split(',');
        if (datalist.size() > 0) {
            propContentType = datalist[0].split(';')[0];
            propContentType = propContentType.removeStart('data:');
            inputDataUrl = datalist[1].trim();
        }

        propFileBody = EncodingUtil.base64Decode(inputDataUrl);

        List<Attachment> savedPicture = [SELECT Id,
                Name,
                Body
            FROM Attachment
            WHERE ParentId = :recordId
            AND Name = :Label.Hosp_DefaultPicture];

        if (!savedPicture.isEmpty()) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(ParentId = recordId,
                Name = Label.Hosp_DefaultPicture,
                Body = propFileBody);

        insert currentPicture;

        doneUploadingCroping = true;

        PageReference recordPageReference = Page.Hosp_DoctorView;
        recordPageReference.getParameters().put('id', recordId);
        recordPageReference.setRedirect(true);

        return recordPageReference;
    }

    private void prepareNewRecordAttachment() {
        PageReference cropImagePage = Page.Hosp_DoctorProfileImage;
        String recordId = cropImagePage.getParameters().get('recordId');

        List<Attachment> savedPicture = [SELECT Id,
                Name,
                Body
            FROM Attachment
            WHERE ParentId = :recordId
            AND Name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(ParentId = recordId, Name = Label.Hosp_DefaultPicture, Body = propFileBody);

        insert currentPicture;

        doneUploadingCroping = true;
    }

    private void generateFirstLastName() {
        Doctor__c d = [SELECT Id,
                FirstLastName__c
            FROM Doctor__c
            WHERE Id = :recordId];

        firstLastName = String.format(Label.Upload_picture_title, new List<String>{d.FirstLastName__c});
    }
}