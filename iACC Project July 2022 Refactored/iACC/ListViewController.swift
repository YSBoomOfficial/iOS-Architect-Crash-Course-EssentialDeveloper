//
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
	var items = [ItemViewModel]()

	var service: ItemService?

	override func viewDidLoad() {
		super.viewDidLoad()
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if tableView.numberOfRows(inSection: 0) == 0 {
			refresh()
		}
	}
	
	@objc private func refresh() {
		refreshControl?.beginRefreshing()
		service?.loadItems(completion: handleAPIResult)
	}
	
	private func handleAPIResult(_ result: Result<[ItemViewModel], Error>) {
		switch result {
			case let .success(items):
				self.items = items
				self.refreshControl?.endRefreshing()
				self.tableView.reloadData()

			case let .failure(error):
				self.show(error: error)
				self.refreshControl?.endRefreshing()
		}
	}
}

// MARK: Navigate to different ViewControllers
//  `show(vc, sender: self)` = `navigationController?.pushViewController(vc, animated: true)`
//  `showDetailViewController(vc, sender: self)` = `present(vc, animated: true)`
extension ListViewController {
	@objc func addCard() {
		show(AddCardViewController(), sender: self)
	}
	
	@objc func addFriend() {
		show(AddFriendViewController(), sender: self)
	}
	
	@objc func sendMoney() {
		show(SendMoneyViewController(), sender: self)
	}
	
	@objc func requestMoney() {
		show(RequestMoneyViewController(), sender: self)
	}
}

// MARK: Configure UITableViewCell with ListViewModel
extension UITableViewCell {
	func configure(_ vm: ItemViewModel) {
		textLabel?.text = vm.title
		detailTextLabel?.text = vm.subtitle
	}
}

// MARK: select methods for didSelectRowAt indexPath
extension ListViewController {
	func select(friend: Friend) {
		let vc = FriendDetailsViewController()
		vc.friend = friend
		show(vc, sender: self)
	}

	func select(card: Card) {
		let vc = CardDetailsViewController()
		vc.card = card
		show(vc, sender: self)
	}

	func select(transfer: Transfer) {
		let vc = TransferDetailsViewController()
		vc.transfer = transfer
		show(vc, sender: self)
	}
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension ListViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
		cell.configure(item)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = items[indexPath.row]
		item.select()
	}
}
