//
//  UserInfoNode.swift
//  RefreshCollectionNodeDemo
//
//  Created by ShevaKuilin on 2018/1/23.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import AsyncDisplayKit

class UserInfoNode: ASDisplayNode {
    let avatarImage = MyNetImageNode()
    let userNameNode =  ASTextNode()
    let userIntroNode = ASTextNode()
    
    struct ElementSize {
        static let avatarHeight: CGFloat = 38
        static let avatarWidth: CGFloat = 38
        static let followHeight: CGFloat = 25
        static let followWidth: CGFloat = 51
        static let userNameWidth: CGFloat = UIScreenAttribute.width - 128   // 屏幕宽 - 用户名两边距[58 + 70]
        static let userIntroWidth: CGFloat = UIScreenAttribute.width - 128
    }
    
    struct ElementRadius {
        static let avatarRadius: CGFloat = 19
    }
    
    struct ElementSpacing {
        static let avatarSpacing: CGFloat = 14
        static let userIntroSpacing: CGFloat = 5
        static let followSpacing: CGFloat = 14
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        setUI()
    }
    
    override func didLoad() {
        super.didLoad()
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addTarget(self, action: #selector(clickAvatarImage), forControlEvents: .touchUpInside)
        
        userNameNode.isUserInteractionEnabled = true
        userNameNode.addTarget(self, action: #selector(clickUserName), forControlEvents: .touchUpInside)
    }
    
    private func setUI() {
        avatarImage.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        avatarImage.style.width = ASDimensionMakeWithPoints(ElementSize.avatarWidth)
        avatarImage.style.height = ASDimensionMakeWithPoints(ElementSize.avatarHeight)
        avatarImage.cornerRadius = ElementRadius.avatarRadius
        avatarImage.url = URL(string: "https://avatars0.githubusercontent.com/u/724423?v=3&s=96")
        self.addSubnode(avatarImage)
        
        userNameNode.style.width = ASDimensionMakeWithPoints(ElementSize.userNameWidth)
        userNameNode.attributedText = NSAttributedString(string: "Andry Shevchenko", attributes: kAttributedStyle(kFont(15, true), kColor(39, 91, 140)))
        self.addSubnode(userNameNode)
        
        userIntroNode.style.width = ASDimensionMakeWithPoints(ElementSize.userIntroWidth)
        userIntroNode.attributedText = NSAttributedString(string: "前锋 @AC米兰 · 13小时前", attributes: kAttributedStyle(kFont(12), kColor(138, 154, 169)))
        self.addSubnode(userIntroNode)
    }
    
    @objc private func clickAvatarImage() {
        printLog("点击用户头像 !!")
    }
    
    @objc private func clickUserName() {
        printLog("点击用户名称 !!")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let leftHorizontalStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                        spacing: ElementSpacing.avatarSpacing,
                                                        justifyContent: .start,
                                                        alignItems: .start,
                                                        children: [avatarImage])

        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: ElementSpacing.userIntroSpacing,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [userNameNode, userIntroNode])

        let stackSpec = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 10,
                                          justifyContent: .start,
                                          alignItems: .center,
                                          children: [leftHorizontalStackSpec,
                                                     verticalStackSpec])
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 10, 0, 0), child: stackSpec)
    }
}
