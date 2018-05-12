//
//  RecommendCommentTableCell.swift
//  XDExerciseExample
//
//  Created by xiudou on 2018/4/26.
//  Copyright © 2018年 CoderST. All rights reserved.
//

import UIKit
import YYText
protocol RecommendCommentTableCellDelegate : class {
    func recommendCommentTableCell(_ recommendCommentTableCell : RecommendCommentTableCell, _ didClickedUser : UserInfor)
}
class RecommendCommentTableCell: UITableViewCell {

    weak var delegateComment : RecommendCommentTableCellDelegate?
    fileprivate lazy var contentLabel : YYLabel = YYLabel()
    var commentFrame : RecommendCommentModelFrame?{
        
        didSet{
            guard let commentFrame = commentFrame else { return }
            contentLabel.frame = commentFrame.textFrame
            contentLabel.attributedText = commentFrame.attributedString
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecommendCommentTableCell{
    fileprivate func setupUI(){
        backgroundColor = UIColor(hex: "#EEEEEE")
        contentView.backgroundColor = UIColor(hex: "#EEEEEE")
    }
    
    fileprivate func setupSubViews(){
        contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .red
        contentLabel.textAlignment = .left
        // (UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)
        
        contentLabel.highlightTapAction = {(_ containerView:UIView,text:NSAttributedString,range:NSRange,rect:CGRect)->() in
            // YYTextHighlight *highlight = [containerView valueForKeyPath:@"_highlight"];
            let highlight = containerView.value(forKey: "_highlight") as? YYTextHighlight
            if let userInfo = highlight?.userInfo![XDCommentUserKey] as? UserInfor{
                self.delegateComment?.recommendCommentTableCell(self, userInfo)
            }
            
        }
    }
}
