//
//  TimelineViewController.swift
//  RefreshCollectionNodeDemo
//
//  Created by ShevaKuilin on 2018/1/23.
//  Copyright © 2018年 ShevaKuilin. All rights reserved.
//

import MJRefresh
import AsyncDisplayKit

class TimelineViewController: ASViewController<ASDisplayNode>  {
    
    var rowCount: Int = 0
    
    lazy var timeline = ASTableNode().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = kColor(239, 242, 245)
        $0.view.separatorStyle = .none
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    init(rowCount: Int) {
        self.rowCount = rowCount
        super.init(node: timeline)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefresh()
    }
    
    // NOTE: 设置刷新加载
    private func setRefresh() {
        weak var weakSelf = self
        timeline.view.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.timeline.view.mj_header.beginRefreshing()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                weakSelf?.timeline.view.mj_header.endRefreshing()
                weakSelf?.timeline.reloadData()
            }
        })
        
        timeline.view.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock:{
            weakSelf?.timeline.view.mj_footer.beginRefreshing()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                weakSelf?.timeline.view.mj_footer.endRefreshing()
                weakSelf?.timeline.reloadData()
            })
        })
    }
}

extension TimelineViewController {
    func nextPageWithCompletion(_ block: @escaping (_ results: Int) -> ()) {
        DispatchQueue.main.async {
            block(self.rowCount)
        }
    }
    
    func insertNewRows(_ newRowCount: Int) {
        let section = 0
        var indexPaths = [IndexPath]()
        
        let count = self.rowCount + newRowCount
        
        for row in self.rowCount ..< count {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        self.rowCount = self.rowCount + newRowCount
        if let tableNode = node as? ASTableNode {
            tableNode.insertRows(at: indexPaths, with: .none)
        }
    }
}

extension TimelineViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = TimelinCellNode()
        cellNode.neverShowPlaceholders = true
        cellNode.selectionStyle = .none
        return cellNode
    }
    
    //    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    //        let cellNodeBlock = { () -> ASCellNode in
    //            let cellNode = XTNewVoteTimelineCellNode()
    //            cellNode.selectionStyle = .none
    //            return cellNode
    //        }
    //        return cellNodeBlock
    //    }
}

extension TimelineViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        printLog("进入willBeginBatchFetchWith方法作用域")
        nextPageWithCompletion { (results) in
            self.insertNewRows(results)
            context.completeBatchFetching(true)
        }
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
}
