//
//  CustomImageViewer.swift
//
//  Created by Siddhesh jadhav on 23/12/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol CustomImageViewerDelegate: AnyObject {
    func imageViewerClosed()
}

enum IndexChangeDirection{
    case up
    case down
}

class CustomImageViewer: UIView {
    
    let nibName = "CustomImageViewer"
    
    //MARK: - @IBOutlet
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var view: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    // MARK: - Class properties
    weak var delegate: CustomImageViewerDelegate?
    
    private var arrayCount = 0
    private var currentIndex = 0
    
    var imageArr:[UIImage] = []{
        didSet{
            currentIndex = 0
            arrayCount = (imageArr.count - 1)
            imageCollectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    deinit {
        
    }
    
    //MARK: - UserDefined Functions
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    //MARK: SetUp
    private func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        self.imageCollectionView.register(UINib(nibName: "CustomImageViewerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomImageViewerCollectionViewCell")
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        if Config.iPadDevice{
            layout.itemSize = CGSize(width: 110, height: 110)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }else{
            layout.itemSize = CGSize(width: 80, height: 80)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
        
        currentIndex = 0
        
        if Config.iPadDevice{
            closeBtn.setImage(UIImage(named: "close-iPad"), for: .normal)
            backBtn.setImage(UIImage(named: "back-1-iPad"), for: .normal)
            nextBtn.setImage(UIImage(named: "next-iPad"), for: .normal)
        }
        
        imageScrollView.delegate = self as UIScrollViewDelegate
        imageScrollView.minimumZoomScale = 1
        imageScrollView.maximumZoomScale = 3
    }
    
    private func updateCell(atIndex: Int, atSection: Int, direction: IndexChangeDirection){
        nextBtn.isHidden = false
        backBtn.isHidden = false
        var indexPath:IndexPath = IndexPath(item: currentIndex, section: 0)
        imageCollectionView.cellForItem(at: indexPath)?.isSelected = false
        direction == .up ? (currentIndex += 1) : (currentIndex -= 1)
        indexPath = IndexPath(item: currentIndex, section: 0)
        self.mainImageView.image = self.imageArr[currentIndex]
        imageCollectionView.cellForItem(at: indexPath)?.isSelected = true
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - @IBAction UIButton
    @IBAction private func backArrowAction(_ sender: UIButton) {
        imageScrollView.zoomScale = 1
        if currentIndex == 0{
            backBtn.isHidden = true
        }else{
            if !imageArr.isEmpty{
                updateCell(atIndex: currentIndex, atSection: 0, direction: .down)
            }
        }
    }
    
    @IBAction private func nextArrowAction(_ sender: UIButton) {
        imageScrollView.zoomScale = 1
        if currentIndex == arrayCount{
            nextBtn.isHidden = true
        }else{
            if !imageArr.isEmpty{
                updateCell(atIndex: currentIndex, atSection: 0, direction: .up)
            }
        }
    }
    
    @IBAction private func closeImageViewerAction(_ sender: UIButton) {
        imageScrollView.zoomScale = 1
        delegate?.imageViewerClosed()
    }
    
}

//MARK: - UICollectionViewDelegate
extension CustomImageViewer: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArr.count == 1{
            backBtn.isHidden = true
            nextBtn.isHidden = true
        }else{
            backBtn.isHidden = false
            nextBtn.isHidden = false
        }
        return self.imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomImageViewerCollectionViewCell", for: indexPath) as! CustomImageViewerCollectionViewCell
        cell.imageView.image = self.imageArr[indexPath.row]
        if self.currentIndex == indexPath.row{
            self.mainImageView.image = self.imageArr[currentIndex]
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedIndexPath:IndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.cellForItem(at: selectedIndexPath)?.isSelected = false
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
        imageScrollView.zoomScale = 1
        self.currentIndex = indexPath.row
        self.mainImageView.image = self.imageArr[indexPath.row]
        
        if currentIndex == 0{
            backBtn.isHidden = true
            nextBtn.isHidden = false
        }else if currentIndex == arrayCount{
            nextBtn.isHidden = true
            backBtn.isHidden = false
        }else{
            backBtn.isHidden = false
            nextBtn.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Config.iPadDevice{
            return CGSize(width: 110, height: 110)
        }else{
            return CGSize(width: 80, height: 80)
        }
    }
}

//MARK: - UIScrollViewDelegate
extension CustomImageViewer: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}
