//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ItemService {
	func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}
