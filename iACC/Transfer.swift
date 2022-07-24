//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct Transfer: Equatable {
	let id: Int
	let description: String
	let amount: Decimal
	let currencyCode: String
	let sender: String
	let recipient: String
	let isSender: Bool
	let date: Date
}
