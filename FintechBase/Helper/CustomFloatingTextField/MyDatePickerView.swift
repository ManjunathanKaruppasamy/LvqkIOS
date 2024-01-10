//
//  MyDatePickerView.swift
//
//  Created by SENTHIL KUMAR on 21/07/22.
//

import UIKit
import Foundation

 class M2PDatePicker: UIView {
    static var shared = M2PDatePicker()
    var selectedDate = Date()
    var getSelectedDate: ((Date?) -> Void)?
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.tag = 100
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
        
    }()
    
    private lazy var viewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
        
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        // Apply Primary Color
//        datepicker.setValue(0.8, forKeyPath: "alpha")
        datepicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datepicker.preferredDatePickerStyle = .wheels
            datepicker.setValue(false, forKey: "highlightsToday")
        } else {
            // Fallback on earlier versions
        }
        datepicker.calendar = Calendar.init(identifier: .gregorian)
        datepicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datepicker.contentMode = .scaleToFill
        return datepicker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let pickerToolbar = UIToolbar()
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerToolbar.barStyle = .default
        pickerToolbar.isTranslucent = true
        let width = UIScreen.main.bounds.width * 0.9
        
        // Add items
        let headerLbl = UIBarButtonItem(title: "Select Date", style: .done, target: nil, action: nil)
        headerLbl.tintColor = .primaryColor
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnClicked))
        doneBtn.tintColor = .primaryColor
        
        let flexView = UIView()
        let calculatedwidth =  width > 330 ? width * 0.43 : width * 0.35
        flexView.frame = CGRect(x: 0.0, y: 0.0, width: calculatedwidth, height: 45.0)
        flexView.isUserInteractionEnabled = false
        flexView.tag = 2100
        flexView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
        let flexSpace = UIBarButtonItem(customView: flexView)
        
        // add the items to the toolbar
        pickerToolbar.items = [headerLbl, flexSpace, doneBtn]
        return pickerToolbar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 100 {
            self.dimmedView.removeFromSuperview()
        }
    }
    
    @objc private func doneBtnClicked(_ button: UIBarButtonItem?) {
        formatDate(date: self.selectedDate)
    }
    
    private func formatDate(date: Date?) {
        getSelectedDate?(date ?? Date())
        self.dimmedView.removeFromSuperview()
    }
    
}

// MARK: Initialize UI and its Actions
extension M2PDatePicker {
    
    func m2pAddDatePicker(backGroundColor: UIColor, textColor: UIColor, minDate: Date? = nil, maxDate: Date? = nil, selectedDate: Date? = nil, height: Double? = nil) {
        
        if let topVC = getTopViewController() {
            datePicker.backgroundColor = backGroundColor
            toolBar.backgroundColor = backGroundColor
            datePicker.setValue(textColor, forKey: "textColor")
            datePicker.maximumDate = maxDate
            datePicker.minimumDate = minDate
            datePicker.date = selectedDate ?? Date()
            self.selectedDate = selectedDate ?? Date()
            self.datePickerView(view: topVC.view, height: height)
        }
    }
    
    private func datePickerView(view: UIView, height: Double? = nil) {
        view.addSubview(dimmedView)
        self.dimmedView.addSubview(viewContent)
        self.viewContent.addSubview(self.toolBar)
        self.viewContent.addSubview(self.datePicker)
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewContent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewContent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContent.widthAnchor.constraint(equalTo: dimmedView.widthAnchor, multiplier: 0.9),
            toolBar.heightAnchor.constraint(equalToConstant: 50),
            toolBar.topAnchor.constraint(equalTo: viewContent.topAnchor),
            toolBar.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: self.toolBar.bottomAnchor, constant: 0),
            datePicker.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0)
        ])
        
        if height != nil {
            NSLayoutConstraint.activate([viewContent.heightAnchor.constraint(equalToConstant: height ?? 0.00)])
        } else {
                NSLayoutConstraint.activate([viewContent.heightAnchor.constraint(equalTo: dimmedView.heightAnchor, multiplier: 0.45)])
        }
    }
    
    private func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
