//	
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	private var friendsCache: FriendsCache!

	convenience init(friendsCache: FriendsCache) {
		self.init(nibName: nil, bundle: nil)
		self.friendsCache = friendsCache
		self.setupViewController()
	}

	private func setupViewController() {
		viewControllers = [
			makeNav(for: makeFriendsList(), title: "Friends", icon: "person.2.fill"),
			makeTransfersList(),
			makeNav(for: makeCardsList(), title: "Cards", icon: "creditcard.fill")
		]
	}
	
	private func makeNav(for vc: UIViewController, title: String, icon: String) -> UIViewController {
		vc.navigationItem.largeTitleDisplayMode = .always
		
		let nav = UINavigationController(rootViewController: vc)
		nav.tabBarItem.image = UIImage(
			systemName: icon,
			withConfiguration: UIImage.SymbolConfiguration(scale: .large)
		)
		nav.tabBarItem.title = title
		nav.navigationBar.prefersLargeTitles = true
		return nav
	}
	
	private func makeTransfersList() -> UIViewController {
		let sent = makeSentTransfersList()
		sent.navigationItem.title = "Sent"
		sent.navigationItem.largeTitleDisplayMode = .always
		
		let received = makeReceivedTransfersList()
		received.navigationItem.title = "Received"
		received.navigationItem.largeTitleDisplayMode = .always
		
		let vc = SegmentNavigationViewController(first: sent, second: received)
		vc.tabBarItem.image = UIImage(
			systemName: "arrow.left.arrow.right",
			withConfiguration: UIImage.SymbolConfiguration(scale: .large)
		)
		vc.title = "Transfers"
		vc.navigationBar.prefersLargeTitles = true
		return vc
	}
	
	private func makeFriendsList() -> ListViewController {
		let vc = ListViewController()
		vc.fromFriendsScreen = true
		vc.shouldRetry = true
		vc.maxRetryCount = 2
		vc.title = "Friends"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: vc, action: #selector(vc.addFriend))

		let isPremium = User.shared?.isPremium == true
 		vc.service = FriendsAPIItemServiceAdapter(
			api: .shared,
			cache: isPremium ? friendsCache : NullFriendsCache()
		) { [weak vc] item in
			vc?.select(friend: item)
		}
		return vc
	}

	private func makeCardsList() -> ListViewController {
		let vc = ListViewController()
		vc.fromCardsScreen = true
		vc.shouldRetry = false
		vc.title = "Cards"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: vc, action: #selector(vc.addCard))
		vc.service = CardAPIItemServiceAdapter(api: .shared) { [weak vc] item in
			vc?.select(card: item)
		}
		return vc
	}
	
	private func makeSentTransfersList() -> ListViewController {
		let vc = ListViewController()
		vc.shouldRetry = true
		vc.maxRetryCount = 1
		vc.longDateStyle = true

		vc.navigationItem.title = "Sent"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .done, target: vc, action: #selector(vc.sendMoney))
		vc.fromSentTransfersScreen = true

		vc.service = SentTransfersAPIItemServiceAdapter(
			api: .shared
		) { [weak vc] item in
			vc?.select(transfer: item)
		}
		return vc
	}
	
	private func makeReceivedTransfersList() -> ListViewController {
		let vc = ListViewController()
		vc.fromReceivedTransfersScreen = true

		vc.shouldRetry = true
		vc.maxRetryCount = 1
		vc.longDateStyle = false

		vc.navigationItem.title = "Received"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request", style: .done, target: vc, action: #selector(vc.requestMoney))

		vc.service = ReceivedTransfersAPIItemServiceAdapter(
			api: .shared
		) { [weak vc] item in
			vc?.select(transfer: item)
		}
		return vc
	}
	
}
