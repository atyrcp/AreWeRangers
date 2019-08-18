//
//  MainViewController.swift
//  AreWeRangers
//
//  Created by alien on 2019/8/16.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var mainTitleView: TitleView?
    var mainScrollView: UIScrollView?
    var rangersCollectionView: UICollectionView?
    var elasticCollectionView: UICollectionView?
    var dynamoCollectionView: UICollectionView?
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var rangersCellDataArray = [CellData]() {
        didSet {
            appDelegate.rangersCellDataArray = rangersCellDataArray
        }
    }
    private var elasticCellDataArray = [CellData]() {
        didSet {
            appDelegate.elasticCellDataArray = elasticCellDataArray
        }
    }
    private var dynamoCellDataArray = [CellData]() {
        didSet {
            appDelegate.dynamoCellDataArray = dynamoCellDataArray
        }
    }
    private var savedRangersData = [SavedRangers]()
    private var savedElasticData = [SavedElastic]()
    private var savedDynamoData = [SavedDynamo]()
    private var currentRangersPage = 0
    private var currentElasticPage = 0
    private var currentDynamoPage = 0
    private let networkManager = NetworkManager()
    
    
    func setupViews() {
        //set up titleVIew
        let titleView = TitleView()
        mainTitleView = titleView
        self.view.addSubview(titleView)
        titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.16).isActive = true
        
        let text = NSMutableAttributedString(string: "RedSo")
        text.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 3, length: 2))
        titleView.titleLabel.attributedText = text
        
        let rangersTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectTeam(gestureRecognizer:)))
        let elasticTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectTeam(gestureRecognizer:)))
        let dynamoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectTeam(gestureRecognizer:)))
        titleView.rangersLabel.addGestureRecognizer(rangersTapGesture)
        titleView.elasticLabel.addGestureRecognizer(elasticTapGesture)
        titleView.dynamoLabel.addGestureRecognizer(dynamoTapGesture)
        
        //set up scrollView
        let scrollView = UIScrollView()
        mainScrollView = scrollView
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        scrollView.delegate = self
        scrollView.backgroundColor = .black
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        
        //set up collectionViews
        var collectionViews = [UICollectionView]()
        for i in 0...2 {
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .black
            collectionView.alwaysBounceVertical = true
            collectionView.delegate = self
            collectionView.dataSource = self
            let refreshControl = UIRefreshControl()
            refreshControl.tag = i
            refreshControl.addTarget(self, action: #selector(reloadCollectionViewData(_:)), for: .valueChanged)
            collectionView.addSubview(refreshControl)
            
            let employeeNib = UINib(nibName: EmployeeCell.nibName(), bundle: nil)
            collectionView.register(employeeNib, forCellWithReuseIdentifier: EmployeeCell.nibName())
            let bannerNib = UINib(nibName: BannerCell.nibName(), bundle: nil)
            collectionView.register(bannerNib, forCellWithReuseIdentifier: BannerCell.nibName())
            collectionViews.append(collectionView)
        }
        rangersCollectionView = collectionViews[0]
        elasticCollectionView = collectionViews[1]
        dynamoCollectionView = collectionViews[2]
    }
    
    func getCellData() {
        guard savedRangersData.isEmpty && savedElasticData.isEmpty && savedDynamoData.isEmpty else {return}
        networkManager.getCellDataUsingCodable(from: .rangers, in: 0) { (APIResponse, err) in
            guard let APIResponse = APIResponse else {return}
            self.rangersCellDataArray = APIResponse.results
            DispatchQueue.main.async {
                self.rangersCollectionView?.reloadData()
            }
        }
        
        networkManager.getCellDataUsingCodable(from: .elastic, in: 0) { (APIResponse, err) in
            guard let APIResponse = APIResponse else {return}
            self.elasticCellDataArray = APIResponse.results
            DispatchQueue.main.async {
                self.elasticCollectionView?.reloadData()
            }
        }
        
        networkManager.getCellDataUsingCodable(from: .dynamo, in: 0) { (APIResponse, err) in
            guard let APIResponse = APIResponse else {return}
            self.dynamoCellDataArray = APIResponse.results
            DispatchQueue.main.async {
                self.dynamoCollectionView?.reloadData()
            }
        }
    }
    
    @objc func selectTeam(gestureRecognizer: UITapGestureRecognizer) {
        var frame = mainScrollView?.frame
        var offsetX: CGFloat = 0
        switch gestureRecognizer.view {
        case mainTitleView?.rangersLabel:
            offsetX = (frame?.width)! * 0
        case mainTitleView?.elasticLabel:
            offsetX = (frame?.width)! * 1
        case mainTitleView?.dynamoLabel:
            offsetX = (frame?.width)! * 2
        default:
            break
        }
        frame?.origin.x = offsetX
        mainScrollView?.contentOffset = CGPoint(x: frame!.origin.x, y: 0)
        mainScrollView?.scrollRectToVisible(frame!, animated: true)
        scrollViewDidEndDecelerating(mainScrollView!)
    }
    
    @objc func reloadCollectionViewData(_ refreshControl: UIRefreshControl) {
        let randomInt = Int.random(in: 0...2)
        switch refreshControl.tag {
        case 0:
            networkManager.getCellDataUsingCodable(from: .rangers, in: randomInt) { (APIResponse, err) in
                guard let APIResponse = APIResponse else {return}
                self.rangersCellDataArray = APIResponse.results
                self.currentRangersPage = randomInt
                DispatchQueue.main.async {
                    self.rangersCollectionView?.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        case 1:
            networkManager.getCellDataUsingCodable(from: .elastic, in: randomInt) { (APIResponse, err) in
                guard let APIResponse = APIResponse else {return}
                self.elasticCellDataArray = APIResponse.results
                self.currentElasticPage = randomInt
                DispatchQueue.main.async {
                    self.elasticCollectionView?.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        case 2:
            networkManager.getCellDataUsingCodable(from: .dynamo, in: randomInt) { (APIResponse, err) in
                guard let APIResponse = APIResponse else {return}
                self.dynamoCellDataArray = APIResponse.results
                self.currentDynamoPage = randomInt
                DispatchQueue.main.async {
                    self.dynamoCollectionView?.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView != rangersCollectionView, scrollView != elasticCollectionView, scrollView != dynamoCollectionView else {return}
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let currentSelectionView = mainTitleView?.currentSelectionView
        let height = currentSelectionView?.frame.height
        let originY = (currentSelectionView?.frame.origin.y)!
        var width: CGFloat = 0
        var dextinationX: CGFloat = 0
        
        switch page {
        case 0:
            width = mainTitleView?.rangersLabel.textWidth() ?? 0
            dextinationX = ((mainTitleView?.rangersLabel.frame.width)! - width) / 2
        case 1:
            width = mainTitleView?.elasticLabel.textWidth() ?? 0
            dextinationX = (((mainTitleView?.elasticLabel.frame.width)! - width) / 2) + (mainTitleView?.elasticLabel.frame.width)!
        case 2:
            width = mainTitleView?.dynamoLabel.textWidth() ?? 0
            dextinationX = (((mainTitleView?.dynamoLabel.frame.width)! - width) / 2) + (mainTitleView?.dynamoLabel.frame.width)! * 2
        default:
            break
        }
        UIView.animate(withDuration: 0.1) {
            currentSelectionView?.frame = CGRect(x: dextinationX + 8, y: originY, width: width, height: height!)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != mainScrollView else {return}
        guard scrollView.contentOffset.y >= 0 else {return}
        
        var isGettingCellData = false
        if !isGettingCellData {
            switch scrollView {
            case rangersCollectionView:
                let newPageInt = (currentRangersPage + 1) % 3
                currentRangersPage = newPageInt
                networkManager.getCellDataUsingCodable(from: .rangers, in: newPageInt) { (APIResponse, err) in
                    guard let APIResponse = APIResponse else {return}
                    self.rangersCellDataArray.append(contentsOf: APIResponse.results)
                    DispatchQueue.main.async {
                        self.rangersCollectionView?.reloadData()
                        isGettingCellData.toggle()
                    }
                }
            case elasticCollectionView:
                let newPageInt = (currentElasticPage + 1) % 3
                currentElasticPage = newPageInt
                networkManager.getCellDataUsingCodable(from: .elastic, in: newPageInt) { (APIResponse, err) in
                    guard let APIResponse = APIResponse else {return}
                    self.elasticCellDataArray.append(contentsOf: APIResponse.results)
                    DispatchQueue.main.async {
                        self.elasticCollectionView?.reloadData()
                        isGettingCellData.toggle()
                    }
                }
            case dynamoCollectionView:
                let newPageInt = (currentDynamoPage + 1) % 3
                currentDynamoPage = newPageInt
                networkManager.getCellDataUsingCodable(from: .dynamo, in: newPageInt) { (APIResponse, err) in
                    guard let APIResponse = APIResponse else {return}
                    self.dynamoCellDataArray.append(contentsOf: APIResponse.results)
                    DispatchQueue.main.async {
                        self.dynamoCollectionView?.reloadData()
                        isGettingCellData.toggle()
                    }
                }
            default:
                break
            }
        }
        
    }
    
    func retrieveCoreData() {
        do {
            savedRangersData = try context.fetch(SavedRangers.fetchRequest())
            savedElasticData = try context.fetch(SavedElastic.fetchRequest())
            savedDynamoData = try context.fetch(SavedDynamo.fetchRequest())
            for data in savedRangersData {
                let cellData = data.transforToCellData()
                rangersCellDataArray.append(cellData)
            }
            for data in savedElasticData {
                let cellData = data.transforToCellData()
                elasticCellDataArray.append(cellData)
            }
            for data in savedDynamoData {
                let cellData = data.transforToCellData()
                dynamoCellDataArray.append(cellData)
            }
            rangersCollectionView?.reloadData()
            elasticCollectionView?.reloadData()
            dynamoCollectionView?.reloadData()
        } catch {
            let error = error as Error
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.08705642074, green: 0.1186198518, blue: 0.264436543, alpha: 1)
        setupViews()
        retrieveCoreData()
        getCellData()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let width = mainScrollView?.frame.width
        let height = mainScrollView?.frame.height
        
        mainScrollView?.contentSize = CGSize(width: width! * 3, height: height!)
        mainScrollView?.addSubview(rangersCollectionView!)
        mainScrollView?.addSubview(elasticCollectionView!)
        mainScrollView?.addSubview(dynamoCollectionView!)
        rangersCollectionView?.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
        elasticCollectionView?.frame = CGRect(x: width!, y: 0, width: width!, height: height!)
        dynamoCollectionView?.frame = CGRect(x: width! * 2, y: 0, width: width!, height: height!)
        
        let currentSelectionView = mainTitleView?.currentSelectionView
        let currentSelectionViewHeight = currentSelectionView?.frame.height
        let originY = (currentSelectionView?.frame.origin.y)!
        let currentSelectionViewWidth = mainTitleView?.rangersLabel.textWidth() ?? 0
        let dextinationX = ((mainTitleView?.rangersLabel.frame.width)! - currentSelectionViewWidth) / 2
        currentSelectionView?.frame = CGRect(x: dextinationX + 8, y: originY, width: currentSelectionViewWidth, height: currentSelectionViewHeight!)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case rangersCollectionView:
            return rangersCellDataArray.count
        case elasticCollectionView:
            return elasticCellDataArray.count
        case dynamoCollectionView:
            return dynamoCellDataArray.count
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellData = CellData(type: "", id: nil, name: nil, position: nil, expertise: nil, avatar: nil, url: nil)
        
        switch collectionView {
        case rangersCollectionView:
            cellData = rangersCellDataArray[indexPath.item]
        case elasticCollectionView:
            cellData = elasticCellDataArray[indexPath.item]
        case dynamoCollectionView:
            cellData = dynamoCellDataArray[indexPath.item]
        default:
            break
        }
        
        let type = cellData.type
        switch type {
        case "employee":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeeCell.nibName(), for: indexPath) as! EmployeeCell
            cell.setOutlook(from: cellData, in: cell.frame.width)
            return cell
        case "banner":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.nibName(), for: indexPath) as! BannerCell
            cell.setOutlook(from: cellData)
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        let height = self.view.bounds.height / 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
