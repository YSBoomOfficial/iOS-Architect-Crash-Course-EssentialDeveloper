//	
// Copyright © Essential Developer. All rights reserved.
//

import UIKit

extension UIViewController {
	var presenterVC: UIViewController {
		parent?.presenterVC ?? parent ?? self
	}
}
