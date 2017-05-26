Bitcoin.KeyPool = (function () {
	var KeyPool = function () {
		this.keyArray = [];

		this.push = function (item) {
			if (item == null || item.priv == null) return;
			var doAdd = true;
			// prevent duplicates from being added to the array
			for (var index in this.keyArray) {
				var currentItem = this.keyArray[index];
				if (currentItem != null && currentItem.priv != null && item.getBitcoinAddress() == currentItem.getBitcoinAddress()) {
					doAdd = false;
					break;
				}
			}
			if (doAdd) this.keyArray.push(item);
		};

		this.reset = function () {
			this.keyArray = [];
		};

		this.getArray = function () {
			// copy array
			return this.keyArray.slice(0);
		};

		this.setArray = function (ka) {
			this.keyArray = ka;
		};

		this.length = function () {
			return this.keyArray.length;
		};

		this.toString = function () {
			var keyPoolString = "# = " + this.length() + "\n";
			var pool = this.getArray();
			for (var index in pool) {
				var item = pool[index];
				if (Bitcoin.Util.hasMethods(item, 'getBitcoinAddress', 'toString')) {
					if (item != null) {
						keyPoolString += "\"" + item.getBitcoinAddress() + "\"" + ", \"" + item.toString("wif") + "\"\n";
					}
				}
			}

			return keyPoolString;
		};

		return this;
	};

	return new KeyPool();
})();
