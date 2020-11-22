//
//  HomeHeaderView.swift
//  Monotone
//
//  Created by Xueliang Chen on 2020/11/15.
//

import UIKit

import SnapKit
import HMSegmentedControl

import RxSwift
import RxCocoa

class HomeHeaderView: BaseView {
    
    public let searchQuery: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    public let listOrderBy: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    public let topic: BehaviorRelay<String> = BehaviorRelay<String>(value: "")

    private var searchTextField: UITextField?
    
    private var segmentedControl: HMSegmentedControl?
    private var listOrderByContent: KeyValuePairs<String, String> {
        return [
            "popular" : NSLocalizedString("unsplash_home_segment_popular", comment: "Popular"),
            "lastest" : NSLocalizedString("unsplash_home_segment_lastest", comment: "Lastest")
        ]
    }
    private var topicContent: KeyValuePairs<String, String> {
        return [
            "nature" : NSLocalizedString("unsplash_home_segment_nature", comment: "Nature"),
            "people" : NSLocalizedString("unsplash_home_segment_people", comment: "People"),
            "street-photography" : NSLocalizedString("unsplash_home_segment_street_photography", comment: "Street Photography"),
            "arts-culture" : NSLocalizedString("unsplash_home_segment_arts_culture", comment: "Arts & Culture"),
            "architecture" : NSLocalizedString("unsplash_home_segment_architecture", comment: "Architecture"),
            "travel" : NSLocalizedString("unsplash_home_segment_travel", comment: "Travel"),
            "technology" : NSLocalizedString("unsplash_home_segment_technology", comment: "Technology"),
            "animals" : NSLocalizedString("unsplash_home_segment_animals", comment: "Animals"),
            "food-drink" : NSLocalizedString("unsplash_home_segment_food_drink", comment: "Food & Drink"),
            "sustainability" : NSLocalizedString("unsplash_home_segment_sustainability", comment: "Sustainability"),
        ]
    }
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func buildSubviews() {
        
        // 
        self.backgroundColor = ColorPalette.colorWhite
        
        // searchTextField.
        let searchImageView: UIImageView = UIImageView()
        searchImageView.image = UIImage(named: "header-input-search")
        
        let attributedSearch = NSAttributedString(string: NSLocalizedString("unsplash_home_search", comment: "Search"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        
        self.searchTextField = MTTextField()
        self.searchTextField!.backgroundColor = ColorPalette.colorGrayLighter
        self.searchTextField!.placeholder = "Search"
        self.searchTextField!.attributedPlaceholder = attributedSearch
        self.searchTextField!.leftView = searchImageView
        self.searchTextField!.leftViewMode = .unlessEditing
        self.searchTextField!.layer.cornerRadius = 4.0
        self.searchTextField!.layer.masksToBounds = true
        self.searchTextField!.returnKeyType = .search
        self.addSubview(self.searchTextField!)
        self.searchTextField!.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(16.0)
            make.right.equalTo(self).offset(-16.0)
            make.top.equalTo(self).offset(50.0)
            make.height.equalTo(36.0)
        })
        
        // segmentedControl
        let segmentedValues = Array(self.listOrderByContent.map({ $0.value })) + Array(self.topicContent.map({ $0.value }))
        self.segmentedControl = HMSegmentedControl(sectionTitles: segmentedValues)
        self.segmentedControl!.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : ColorPalette.colorGrayNormal
        ]
        self.segmentedControl!.selectedTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : ColorPalette.colorBlack
        ]
        self.segmentedControl!.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.bottom
        self.segmentedControl!.selectionIndicatorColor = ColorPalette.colorBlack
        self.segmentedControl!.selectionIndicatorHeight = 2.0
        self.segmentedControl!.segmentEdgeInset = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
        self.segmentedControl!.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.dynamic
        self.segmentedControl!.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
        self.addSubview(self.segmentedControl!)
        self.segmentedControl!.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15.0)
            make.right.equalTo(self).offset(-15.0)
            make.bottom.equalTo(self)
            make.height.equalTo(40.0)
        }
    }
    
    override func buildLogic() {
        
        // searchTextField
        self.searchTextField!.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { (_) in
                self.searchQuery.accept(self.searchTextField!.text ?? "")
            })
            .disposed(by: self.disposeBag)
        
        // segmentedControl
        Observable.of(self.listOrderBy, self.topic)
            .merge()
            .distinctUntilChanged()
            .filter({ $0 != ""})
            .flatMap { (key) -> Observable<Int> in
                let segmentedKeys = Array(self.listOrderByContent.map({ $0.key })) + Array(self.topicContent.map({ $0.key }))
                let index = segmentedKeys.firstIndex { $0 == key } ?? -1
                
                return Observable.just(index)
            }
            .filter({ NSDecimalNumber(value: $0) !=  NSDecimalNumber(value: self.segmentedControl!.selectedSegmentIndex) })
            .subscribe(onNext: { (index) in
                self.segmentedControl!.setSelectedSegmentIndex(index == -1 ? HMSegmentedControlNoSegment : UInt(index), animated: false)
            })
            .disposed(by: self.disposeBag)
        
        self.searchQuery
            .distinctUntilChanged()
            .filter({ $0 != ""})
            .subscribe { (value) in
                self.listOrderBy.accept("")
                self.topic.accept("")
            }
            .disposed(by: self.disposeBag)
        
        self.listOrderBy
            .distinctUntilChanged()
            .filter({ $0 != ""})
            .subscribe { (value) in
                self.searchQuery.accept("")
                self.topic.accept("")
            }
            .disposed(by: self.disposeBag)
        
        self.topic
            .distinctUntilChanged()
            .filter({ $0 != ""})
            .subscribe { (value) in
                self.searchQuery.accept("")
                self.listOrderBy.accept("")
            }
            .disposed(by: self.disposeBag)
        
//        self.listOrderBy
//            .flatMap { (segmentStr) -> Observable<Int> in
//                let index = self.segmentedControl!.sectionTitles!.firstIndex(of: segmentStr) ?? -1
//                return Observable.just(index)
//            }
//            .subscribe(onNext: { (index) in
//                if(index != -1){
//                    self.segmentedControl!.setSelectedSegmentIndex(UInt(index), animated: false)
//                }
//            })
//            .disposed(by: self.disposeBag)
    }

    @objc private func segmentedControlChangedValue(segmentedControl: HMSegmentedControl){
        
        let index = Int(segmentedControl.selectedSegmentIndex)
        
        switch index {
        case 0..<self.listOrderByContent.count:
            self.listOrderBy.accept(self.listOrderByContent[index].key)
            break
            
        case self.listOrderByContent.count..<self.listOrderByContent.count + self.topicContent.count:
            self.topic.accept(self.topicContent[index - self.listOrderByContent.count].key)
            break

        default:
            break
        }
    }
}
