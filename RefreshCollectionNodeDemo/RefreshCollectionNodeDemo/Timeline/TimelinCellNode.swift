//
//  TimelinCellNode.swift
//  RefreshCollectionNodeDemo
//
//  Created by ShevaKuilin on 2018/1/23.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import YYText
import YYImage
import AsyncDisplayKit

class TimelinCellNode: ASCellNode {
    let userInfoNode = UserInfoNode()          // 用户信息
    let photoContenNode = PhotoContentNode()   // 图片内容
    let bottomLintNode = ASImageNode()         // 底部分割线
    let topSeparateNode = ASImageNode()        // 顶部分隔区域
    
    enum ElementScale {
        case photoScale         // 图片比例
        case specialPhotoScale  // 特殊图片比例 [2x2格式]
        case photoSpacing       // 图片间距
        case bottomSpacing      // 底部间距
        case photoMargin        // 图片边距
        
        static var value : CGFloat = 0.0
        var instanceConstraint : CGFloat {
            switch self {
            case .photoScale: UIScreenAttribute.width == 320 ? (ElementScale.value = 3.1):(ElementScale.value = 3.08)
            case .specialPhotoScale: UIScreenAttribute.width == 320 ? (ElementScale.value = 3.045
                ):(ElementScale.value = 3.038)
            case .photoSpacing: ElementScale.value = 4.0
            case .bottomSpacing: ElementScale.value = 12.0
            case .photoMargin: ElementScale.value = 14.0
            }
            
            return ElementScale.value
        }
    }
    
    struct ElementSize {
        static let userInfoHeight: CGFloat = 60
        static let userInfoWidth: CGFloat = UIScreenAttribute.width
        static let photoContenWidth: CGFloat = UIScreenAttribute.width - 28
        static let bottomWidth: CGFloat = UIScreenAttribute.width
        static let bottomHeight: CGFloat = 38
        static let bottomLineHeight: CGFloat = 1
        static let topSeparateWidth: CGFloat = UIScreenAttribute.width
        static let topSeparateHeight: CGFloat = 9
        
        static let photoNodeHeightNone: CGFloat = 0
        static let photoNodeHeightOnce: CGFloat = (UIScreenAttribute.width - (ElementScale.photoMargin.instanceConstraint * 2)) / ElementScale.photoScale.instanceConstraint
        static let photoNodeHeightDouble: CGFloat = (ElementSize.photoNodeHeightOnce * 2) + 8
        static let photoNodeHeightTriplex: CGFloat = (ElementSize.photoNodeHeightOnce * 3) + 12
    }
    
    struct ElementSpacing {
        static let textContentSpacing: CGFloat = 14
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        setUI()
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    private func setUI() {
        userInfoNode.style.height = ASDimensionMakeWithPoints(ElementSize.userInfoHeight)
        userInfoNode.style.width = ASDimensionMakeWithPoints(ElementSize.userInfoWidth)
        self.addSubnode(userInfoNode)
        
        photoContenNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoContenWidth)
        photoContenNode.imagesCount = 4//kRandomInRange(0, 9)
        if photoContenNode.imagesCount == 4 {
            photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble + 23)
            photoContenNode.style.width = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble - 2.2)
            
        } else {
            if photoContenNode.imagesCount == 0 {
                photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightNone + 13)
            } else if photoContenNode.imagesCount < 4 && photoContenNode.imagesCount > 0 {
                photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightOnce + 23)
            } else if photoContenNode.imagesCount > 3 && photoContenNode.imagesCount < 7 {
                photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightDouble + 23)
            } else if photoContenNode.imagesCount <= 9 && photoContenNode.imagesCount > 6 {
                photoContenNode.style.height = ASDimensionMakeWithPoints(ElementSize.photoNodeHeightTriplex + 23)
            }
        }
        
        self.addSubnode(photoContenNode)

        
        bottomLintNode.style.width = ASDimensionMakeWithPoints(ElementSize.bottomWidth)
        bottomLintNode.style.height = ASDimensionMakeWithPoints(ElementSize.bottomLineHeight)
        bottomLintNode.backgroundColor = kColor(186, 186, 186, 0.5)
        self.addSubnode(bottomLintNode)
        
        topSeparateNode.style.width = ASDimensionMakeWithPoints(ElementSize.topSeparateWidth)
        topSeparateNode.style.height = ASDimensionMakeWithPoints(ElementSize.topSeparateHeight)
        topSeparateNode.backgroundColor = kColor(239, 242, 245)
        self.addSubnode(topSeparateNode)
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 0,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [topSeparateNode, userInfoNode, photoContenNode, bottomLintNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 0, 0, 0), child: verticalStackSpec)
    }
}

