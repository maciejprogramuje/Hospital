public class Hosp_DoctorProfileImageController {
    Public Transient blob propFileBody { get; set; }
    Public Transient string propFileName { get; set; }
    Public Transient string propContentType { get; set; }
    Public Integer fsize { get; set; }
    public boolean doneuploading { get; set; }
    public boolean doneuploadingCroping { get; set; }
    public boolean uploadCroping { get; set; }
    public Transient string upldocUrl { get; set; }
    public Transient String inputdataUrl { get; set; }
    public String DocID { get; set; }
    public String recordId { get; set; }

    public Hosp_DoctorProfileImageController() {
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        try {
            upldocUrl = '';
            inputdataUrl = '';
            uploadCroping = false;
            doneuploading = false;
            doneuploadingCroping = false;
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString() + ' Message: SaveProfile() ' + ex.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    public Pagereference uploadPicture() {
        try {
            Transient User UserContactId;
            if (!uploadCroping) {
                return EditProfilePic();
            } else {
                return uploadCrop();
            }
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString() + ' Message: SaveProfile() ' + ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public Pagereference EditProfilePic() {
        try {
            system.debug('@@@@# propFileBody' + propFileBody + '' + propFileName + '' + propContentType + 'fsize' + fsize + 'propFileName' + propFileName);

            // checking file size should be less then 5 MB
            if (fsize > 2097152) {
                List<String> messageComponents = new List<String>{};

                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, String.format(Label.Image_too_large, new List<String>{propFileName}));
                ApexPages.addMessage(msg);
            } else if ((propContentType != 'image/png') && (propContentType != 'image/jpeg')) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Image_invalid_type);
                ApexPages.addMessage(msg);
            } else {
                String strtemp = EncodingUtil.base64Encode(propFileBody);
                if (!String.isblank(strtemp)) {
                    upldocUrl = 'data:' + propContentType + ';base64,' + strtemp;    // set the image url to display image on the page
                } else {
                    upldocUrl = '';
                }
                doneuploading = true;
            }
        } catch (Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString() + ' Message: ' + ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public Pagereference uploadCrop() {
        List<String> datalist = inputdataUrl.split(',');
        if (datalist.size() > 0) {
            propContentType = datalist[0].split(';')[0];
            propContentType = propContentType.removeStart('data:');
            inputdataUrl = datalist[1].trim();
        }

        propFileBody = EncodingUtil.base64Decode(inputdataUrl);

        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :recordId AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(parentId = recordId, name = Label.Hosp_DefaultPicture, body = propFileBody);
        insert currentPicture;

        doneuploadingCroping = true;

        PageReference recordPageReference = Page.Hosp_DoctorView;
        recordPageReference.getParameters().put('id', recordId);
        recordPageReference.setRedirect(true);

        return recordPageReference;
    }

    private void prepareNewRecordAttachment() {
        PageReference cropImagePage = Page.Hosp_DoctorProfileImage;
        String recordId = cropImagePage.getParameters().get('recordId');

        List<Attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :recordId AND name = :Label.Hosp_DefaultPicture];
        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(parentId = recordId, name = Label.Hosp_DefaultPicture, body = propFileBody);

        insert currentPicture;

        doneuploadingCroping = true;
    }
}