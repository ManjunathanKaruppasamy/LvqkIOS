//
//  LoaderView.swift
//  FintechBase
//
//  Created by SENTHIL KUMAR on 03/03/23.
//

import UIKit
import Lottie

class LoaderView: UIView {

    @IBOutlet weak var loaderTitleLbl: UILabel?
    @IBOutlet weak var lottiLoaderView: LottieAnimationView?
    @IBOutlet weak var viewContent: UIView?
    
    var titleText = "Loading..."
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let view = viewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.setAnimaionView()
        self.loaderTitleLbl?.text = self.titleText
        self.viewContent?.layer.cornerRadius = 32
    }
    private func viewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }
    
    // MARK: Set Lottie AnimaionView
    private func setAnimaionView() {
        lottiLoaderView?.contentMode = .scaleAspectFill
        lottiLoaderView?.loopMode = .loop
        lottiLoaderView?.play()
    }
}
