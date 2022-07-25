//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ItemService {
	func loadFriends(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}
