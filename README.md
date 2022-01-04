# CustomImageViewer - Like Skype

**Example**

```
 USES : - Add Custom Image Viewer folder into project
 
class CustomImageViewerExample {
 
    // step 1
    @IBOutlet var customImageViewer: CustomImageViewer!
    
    // data
    let imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        // step 2
        customImageViewer.frame = self.view.frame
        self.view.addSubview(customImageViewer)
        customImageViewer.isHidden = true
        customImageViewer.delegate = self
    }
    
    // step 4
    func openImageViewer(){
        if !imageArray.isEmpty{
            customImageViewer.isHidden = false
            customImageViewer.imageArr = self.imageArray
            self.view.bringSubviewToFront(customImageViewer)
        }
    }
}

 // step 3
extension CustomImageViewerExample: CustomImageViewerDelegate{
    func imageViewerClosed(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.customImageViewer.isHidden = true
    }
}

```
