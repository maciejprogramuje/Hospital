public with sharing class Hosp_DoctorProfileImageController {
/**********Profile Pic***************/
    public Doctor__c doctor{get;set;}
    Public Transient blob propFileBody{get; set;}
    Public Transient string propFileName{get;set;}
    Public Transient string propContentType{get;set;}
    Public Integer fsize{get;set;}
    public boolean doneuploading{get; set;}
    public boolean doneuploadingCroping{get; set;}
    public boolean uploadCroping{get; set;}
    Public Transient string upldocUrl{get;set;}
    Public Transient String inputdataUrl{get;set;}
    Public String DocID{get;set;}
    public String recordId;
    public String pageReferenceUrl;


    public Hosp_DoctorProfileImageController() {
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        pageReferenceUrl = ApexPages.currentPage().getParameters().get('pageReferenceURL');
        setupPictureVariables();
    }

    public void setupPictureVariables()
    {
        try
        {
            upldocUrl='';
            inputdataUrl='';
            uploadCroping=true;
            doneuploading=false;
            doneuploadingCroping=false;
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()+' Message: SaveProfile() '+ex.getMessage());
            ApexPages.addMessage(msg);
        }
    }

    public Pagereference uploadPicture()
    {
        try
        {
            Transient User UserContactId;
            if(!uploadCroping)
                return EditProfilePic();
            else
                    return prepareNewRecordAttachment();
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()+' Message: SaveProfile() '+ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    public Pagereference EditProfilePic()
    {
        try
        {
            system.debug('@@@@# propFileBody'+propFileBody+''+propFileName+''+propContentType+'fsize'+fsize+'propFileName'+propFileName);

            // checking file size should be less then 5 MB
            if(fsize > 5242880)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to upload '+propFileName+' because it exceeds the maximum file size (5MB).');
                ApexPages.addMessage(msg);
            }
            else if((propContentType != 'image/png') && (propContentType != 'image/x-png') && (propContentType  != 'image/pjpeg') && (propContentType != 'image/jpeg') && (propContentType != 'image/gif') && (propContentType  != 'image/bmp')&& (propContentType  != 'image/tiff'))
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: File Type Not Correct.');
                ApexPages.addMessage(msg);
            }
            else
            {
                String strtemp=EncodingUtil.base64Encode(propFileBody);
                if(!String.isblank(strtemp))
                    upldocUrl='data:'+propContentType+';base64,'+strtemp;    // set the image url to display image on the page
                else
                        upldocUrl='';
                doneuploading=true;
            }
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()+' Message: '+ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }

    private PageReference prepareNewRecordAttachment() {
        List<attachment> savedPicture = [SELECT Id, name, body FROM Attachment WHERE parentId = :recordId AND name = :Label.Hosp_DefaultPicture];

        if (savedPicture.size() > 0) {
            delete savedPicture;
        }

        Attachment currentPicture = new Attachment(parentId = recordId, name = Label.Hosp_DefaultPicture, body = propFileBody);
        insert currentPicture;
        doneuploadingCroping = true;
    }

    /*public Pagereference uploadCrop()
    {
        try
        {
            doneuploadingCroping=false;
            if(!string.isblank(inputdataUrl))
            {
                List<String> datalist = inputdataUrl.split(',');
                if(datalist.size()>0)
                {
                    propContentType=datalist[0].split(';')[0];
                    propContentType=propContentType.removeStart('data:');
                    inputdataUrl=datalist[1].trim();
                }

                propFileBody=EncodingUtil.base64Decode(inputdataUrl);

                Document doc = new Document();
                doc.Body = propFileBody;
                doc.Name = 'ABC';
                doc.IsPublic = true;
                doc.ContentType = propContentType;
                doc.Type = propContentType.substring((propContentType.indexOf('/')+1),propContentType.length());
                doc.FolderId = UserInfo.getUserId();
                System.debug('doc------'+doc);
                insert doc;
                DocID = doc.Id;
                doneuploadingCroping=true;
            }
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getStackTraceString()+' Message: '+ex.getMessage());
            ApexPages.addMessage(msg);
        }
        return null;
    }*/
}