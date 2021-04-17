//
//  FormTableViewCell.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/16/21.
//

import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell {
    
    static let identifier = "FormTableViewCell"
    
    private var model: EditProfileFormModel?
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let formTextField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(formTextField)
        selectionStyle = .none
        formTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formLabel.text = model.label
        formTextField.placeholder = model.placeholder
        formTextField.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        formTextField.placeholder = nil
        formTextField.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //  Assign frames
        formLabel.frame = CGRect(x: 5, y: 0, width: contentView.width/3, height: contentView.height)
        formTextField.frame = CGRect(x: formLabel.right + 5, y: 0, width: contentView.width-10-formLabel.height, height: contentView.height)
    }
}

extension FormTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else { return true }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
}
