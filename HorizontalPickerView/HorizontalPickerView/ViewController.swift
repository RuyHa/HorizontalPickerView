//
//  ViewController.swift
//  HorizontalPickerView
//
//  Created by Ruyha on 2022/11/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var hPickerView: HorizontalPickerView = {
        let view = HorizontalPickerView()
        //피커의 초깃값
        view.pickerSelectValue = 0
        //델리게이트 설정
        view.delegate = self
        //초기에 보여지는 문구
        view.customTitle = "슬라이드 해주세요"
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        view.backgroundColor = .customBlue

        // Do any additional setup after loading the view.
    }

}

// MARK: HorizontalPickerViewDelegate
extension ViewController : HorizontalPickerViewDelegate {
    
    func didLevelChanged(selectedLevel: Int) {
        print("변경된 값은?:\(selectedLevel)")
    }
    
}

// MARK: SnapKit

extension ViewController {
    
    func setUpLayout(){
        
        view.addSubview(hPickerView)
        hPickerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.center.equalToSuperview()
            $0.height.equalTo(120)
        }
        
    }
}
