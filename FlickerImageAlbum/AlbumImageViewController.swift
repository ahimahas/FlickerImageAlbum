//
//  ViewController.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 16..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import UIKit

enum ViewMode {
    case start
    case display
}

enum AlbumImageAnimationMode {
    case on
    case off
}

final class AlbumImageViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var animationOnOffButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    struct Constant {
        static let menuViewHideBottomConstraint: CGFloat = -60
        static let timeSliderDefaultValue: Float = 10
    }
    
    public var viewModel: AlbumImageViewModelProtocol?
    
    lazy private var viewMode: ViewMode = .start
    lazy private var albumImageAnimationMode: AlbumImageAnimationMode = .on
    
    private var isMenuViewPresenting: Bool {
        return !(menuViewBottomConstraint.constant == Constant.menuViewHideBottomConstraint)
    }
    
    var timer: Timer?
    var sliderValueForTimer: TimeInterval {
        return TimeInterval(Float(lroundf(timeSlider.value)))
    }
    
    
    //! MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        self.resetSubviewsSetup()
    }

    
    //! MARK: - Action Handler Methods
    
    @IBAction func didStartButtonTouched(_ sender: Any) {
        changeViewMode(to: .display)
        
        indicator.startAnimating()
        viewModel?.prepareForUse(withComplete: { (success) in
            self.indicator.stopAnimating()
        })
    }
    
    @IBAction func didBackButtonTouched(_ sender: Any) {
        changeAlbumImageAnimationMode(to: .on)
        resetSubviewsSetup()
        
        changeViewMode(to: .start)
    }
    
    @IBAction func didAnimationOnOffButtonTouched(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            changeAlbumImageAnimationMode(to: .off)
        } else {
            changeAlbumImageAnimationMode(to: .on)
        }
    }
    
    @IBAction func didTimeSliderValueChanged(_ sender: UISlider) {
        let roundedValue: Float = Float(lroundf(sender.value))
        sender.setValue(roundedValue, animated: false)
        
        let roundedStringValue = String(format:"%.f", roundedValue)
        timeLabel.text = "\(roundedStringValue) sec"
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(roundedValue), target: self, selector: #selector(self.didTimerCallbackReceived), userInfo: nil, repeats: true)
    }
    
    @IBAction func didAlbumImageViewTapped(_ sender: Any) {
        toggleMenuView()
    }
    
    func didTimerCallbackReceived(_ sender: Timer) {
        viewModel?.nextImageData(withCompletion: { (data) in
            guard let data = data else {
                return
            }
            
            UIView.animate(withDuration: 0.15, animations: {
                self.albumImageView.alpha = 0
            }, completion: { (success) in
                self.albumImageView.image = UIImage(data: data)
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.albumImageView.alpha = 1
                })
            })
        })
    }
    
    
    //! MARK: - Private Methods
    
    private final func changeViewMode(to mode: ViewMode) {
        switch mode {
        case .start:
            startButton.isHidden = false
            albumImageView.isHidden = true
            menuView.isHidden = true
            
        case .display:
            startButton.isHidden = true
            albumImageView.isHidden = false
            menuView.isHidden = false
        }
        
        viewMode = mode
    }
    
    private final func changeAlbumImageAnimationMode(to mode: AlbumImageAnimationMode) {
        switch mode {
        case .on:
            timeSlider.isEnabled = true
            timeLabel.isEnabled = true
            
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: self.sliderValueForTimer, target: self, selector: #selector(self.didTimerCallbackReceived), userInfo: nil, repeats: true)
            }
        case .off:
            timeSlider.isEnabled = false
            timeLabel.isEnabled = false
            
            DispatchQueue.main.async {
                self.timer?.invalidate()
            }
        }
        
        albumImageAnimationMode = mode
    }
    
    private final func toggleMenuView() {
        if isMenuViewPresenting {
            menuViewBottomConstraint.constant = Constant.menuViewHideBottomConstraint
        } else {
            menuViewBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private final func resetSubviewsSetup() {
        menuViewBottomConstraint.constant = 0
        animationOnOffButton.isSelected = false
        albumImageView.alpha = 1
        albumImageView.image = nil
        timeSlider.setValue(Constant.timeSliderDefaultValue, animated: false)
        timeLabel.text = "\(String(format:"%.f", Constant.timeSliderDefaultValue)) sec"
        
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}


//! MARK: - AlbumImageViewModelDelegate Imp
extension AlbumImageViewController: AlbumImageViewModelDelegate {
    
    func didImageUrlsChanged() {    
        self.indicator.startAnimating()
        
        viewModel?.nextImageData(withCompletion: { [weak self] (data) in
            guard let `self` = self else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            self.indicator.stopAnimating()
            self.albumImageView.image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: self.sliderValueForTimer, target: self, selector: #selector(self.didTimerCallbackReceived), userInfo: nil, repeats: true)
            }
        })
    }
}


