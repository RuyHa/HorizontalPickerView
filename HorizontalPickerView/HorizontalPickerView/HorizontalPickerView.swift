//
//  HorizontalPickerView.swift
//  HorizontalPickerView
//
//  Created by Ruyha on 2022/11/22.
//  같이 고생해준 @sm-amoled 에게 감사를!!

import UIKit
import SnapKit
protocol HorizontalPickerViewDelegate {
    func didLevelChanged(selectedLevel: Int)
}

class HorizontalPickerView: UIView{
    //피커뷰의 고정적으로 쓰이는 넓이
    private var pickerWidth = 64
    //피커뷰가 시작 될때 선택 되어 있어야 하는 값
    var pickerSelectValue = 0
    //초기선택된 레이블을 설정에 사용되는 값
    var isFirstLoad : Bool?
    
    //피커뷰에 들어갈 리스트들
    private let levelValues: [Int] = [0,1,2,3,4,5,6,7,8,9]
    //회전각도
    private var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    private var titleText = "을 선택했어요."
    //타이틀에 다른 문구를 넣고 싶을때
    var customTitle : String?
    
    private var changedLevelPicker = false
    
    var delegate: HorizontalPickerViewDelegate?
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return picker
    }()
    
    lazy var invertedTriangleLabel: UILabel = {
        let imageAttachment = NSTextAttachment()
        let arrowtriangle = NSMutableAttributedString(string: "")
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 8, weight: .light)
        imageAttachment.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.black)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        arrowtriangle.append(NSAttributedString(attachment: imageAttachment))
        label.attributedText = arrowtriangle
        return label
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var pickerSetLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPicker()
        pickerView.subviews[1].isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setPicker() {
        setUpLayout()
        self.backgroundColor = .white
        self.pickerView.delegate?.pickerView?(self.pickerView, didSelectRow: pickerSelectValue, inComponent: 0)
    }
    
    override func layoutSubviews() {
        guard changedLevelPicker else{
            pickerSelectValue =  pickerSelectValue < 0 ? 0 : pickerSelectValue
            pickerSelectValue =  pickerSelectValue < levelValues.count ? levelValues.count : pickerSelectValue

            self.pickerView.selectRow(pickerSelectValue, inComponent: 0, animated: true)
            
            if customTitle != nil {
                titleLabel.text = customTitle
            } else{
                titleLabel.text = "R\(pickerSelectValue)\(titleText)"
            }
            
            if self.frame.height < 110 {
                titleLabel.removeFromSuperview()
            }
            changedLevelPicker = true
            return
        }
    }
    
}
extension HorizontalPickerView : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(pickerWidth)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelValues.count
    }
    
    
    //MARK: 여기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didLevelChanged(selectedLevel: row)
        titleLabel.text = "R\(row)\(titleText)"
        guard let selectView = pickerView.view(forRow: row, forComponent: component) else {
            isFirstLoad = false
            return
        }
        
        let selectLabel = selectView.subviews[0] as! UILabel
        selectLabel.textColor = .white
        selectLabel.font  = .systemRoundedFont(ofSize: 18, weight: .bold)
        selectLabel.backgroundColor = .customBlue
        
        if let beforeView = pickerView.view(forRow: row - 1, forComponent: component) {
            let beforeLabel = beforeView.subviews[0] as! UILabel
            beforeLabel.backgroundColor = .white
            beforeLabel.font = .systemRoundedFont(ofSize: 17, weight: .light)
            beforeLabel.textColor = .black
        }
        if let afterView = pickerView.view(forRow: row + 1, forComponent: component) {
            let afterLabel = afterView.subviews[0] as! UILabel
            afterLabel.backgroundColor = .white
            afterLabel.font = .systemRoundedFont(ofSize: 17, weight: .light)
            afterLabel.textColor = .black
        }
        
        guard let myBool = isFirstLoad else{
            isFirstLoad = false
            return
        }
        
        if !myBool{
            isFirstLoad = true
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerRow = UIView()
        pickerRow.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: 32)
        
        lazy var rowLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.font = UIFont.systemRoundedFont(ofSize: 17, weight: .light)
            label.textAlignment = .center
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            label.backgroundColor = .white
            return label
        }()
        
        pickerRow.addSubview(rowLabel)
        rowLabel.snp.makeConstraints {
            $0.leading.equalTo(pickerRow.snp.leading).offset(8)
            $0.trailing.equalTo(pickerRow.snp.trailing).offset(-8)
            $0.height.equalTo(pickerRow.snp.height)
        }
        
        rowLabel.text = "R\(levelValues[row])"
        pickerRow.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        guard let myBool = isFirstLoad else{
            return pickerRow
        }
        guard !myBool else{
            return pickerRow
        }
        guard let selectView = pickerView.view(forRow: pickerSelectValue, forComponent: component) else {
            return pickerRow
        }
        let selectLabel = selectView.subviews[0] as! UILabel
        selectLabel.textColor = .white
        selectLabel.font = .systemRoundedFont(ofSize: 18, weight: .bold)
        selectLabel.backgroundColor = .customBlue
        return pickerRow
    }
    
}
extension HorizontalPickerView {
    
    private func setUpLayout(){
        
        self.addSubview(pickerSetLabel)
        pickerSetLabel.snp.makeConstraints {
            $0.height.equalTo(pickerWidth)
            $0.width.equalTo(self.snp.width)
            $0.bottom.equalTo(self.snp.bottom)
        }
        
        self.addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.height.equalTo(pickerSetLabel.snp.width)// width
            $0.width.equalTo(pickerSetLabel.snp.height)//height
            $0.centerX.equalTo(pickerSetLabel.snp.centerX)
            $0.centerY.equalTo(pickerSetLabel.snp.centerY)
        }
        
        self.addSubview(invertedTriangleLabel)
        invertedTriangleLabel.snp.makeConstraints {
            $0.centerX.equalTo(pickerSetLabel.snp.centerX)
            $0.bottom.equalTo(pickerSetLabel.snp.top)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(invertedTriangleLabel.snp.top).offset(-8)
        }
    }
}
