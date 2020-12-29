//
//  SideMenuPageView.swift
//  Monotone
//
//  Created by Xueliang Chen on 2020/12/18.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa
import RxSwiftExt

// MARK: - SideMenuPageView
class SideMenuPageView: BaseView{
    
    // MARK: - Public
    public var pages: BehaviorRelay<[(key:SideMenuPage,value:String)]?> = BehaviorRelay<[(key:SideMenuPage,value:String)]?>(value: nil)
    public var selectedPage: BehaviorRelay<(key:SideMenuPage,value:String)?> = BehaviorRelay<(key:SideMenuPage,value:String)?>(value: nil)

    // MARK: - Controls
    private var tableView: UITableView!
    
    private var horizontalTopLineLong: UIView!
    private var horizontalTopLineShort: UIView!
    private var horizontalBottomLineLong: UIView!
    private var horizontalBottomLineShort: UIView!
        
    // MARK: - Private
    private let disposeBag: DisposeBag = DisposeBag()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func buildSubviews() {
        super.buildSubviews()
        
        // TableView.
        self.tableView = UITableView()
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.register(SideMenuOptionTableViewCell.self, forCellReuseIdentifier: "SideMenuOptionTableViewCell")
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(20.0)
            make.bottom.equalTo(self).offset(-20.0)
        }
        
        // HorizontalTopLineLong.
        self.horizontalTopLineLong = UIView()
        self.horizontalTopLineLong.backgroundColor = ColorPalette.colorBlack
        self.addSubview(self.horizontalTopLineLong)
        self.horizontalTopLineLong.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(1.0)
            make.width.equalTo(53.0)
        }
        
        // HorizontalTopLineShort.
        self.horizontalTopLineShort = UIView()
        self.horizontalTopLineShort.backgroundColor = ColorPalette.colorBlack
        self.addSubview(self.horizontalTopLineShort)
        self.horizontalTopLineShort.snp.makeConstraints { (make) in
            make.left.equalTo(self.horizontalTopLineLong.snp.right).offset(8.0)
            make.top.equalTo(self)
            make.height.equalTo(1.0)
            make.width.equalTo(8.0)
        }
        
        // HorizontalBottomLineLong.
        self.horizontalBottomLineLong = UIView()
        self.horizontalBottomLineLong.backgroundColor = ColorPalette.colorBlack
        self.addSubview(self.horizontalBottomLineLong)
        self.horizontalBottomLineLong.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.height.equalTo(1.0)
            make.width.equalTo(53.0)
        }
        
        // HorizontalBottomLineShort.
        self.horizontalBottomLineShort = UIView()
        self.horizontalBottomLineShort.backgroundColor = ColorPalette.colorBlack
        self.addSubview(self.horizontalBottomLineShort)
        self.horizontalBottomLineShort.snp.makeConstraints { (make) in
            make.right.equalTo(self.horizontalBottomLineLong.snp.left).offset(-8.0)
            make.bottom.equalTo(self)
            make.height.equalTo(1.0)
            make.width.equalTo(8.0)
        }
    }
    
    override func buildLogic() {
        super.buildLogic()
        
        // Bindings.
        // Pages.
        self.pages
            .unwrap()
            .bind(to: self.tableView.rx.items(cellIdentifier: "SideMenuOptionTableViewCell")){
                (row, element, cell) in
                
                let pcell: SideMenuOptionTableViewCell = cell as! SideMenuOptionTableViewCell
                pcell.page.accept(element)

            }
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected((key:SideMenuPage,value:String).self)
            .subscribe(onNext:{ [weak self] (keyValuePair) in
                guard let self = self else { return }
                
                self.selectedPage.accept(keyValuePair)

            }).disposed(by: self.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension SideMenuPageView: UITableViewDelegate{
    
}
