var shopping = [];
var totalPrix = 0;

        function addItem() {
            var itemSelect = document.getElementById("item");
            var quantiteInput = document.getElementById("quantity");
            
            var ItemValeur = itemSelect.value;
            var quantiteValeur = parseInt(quantiteInput.value);


            if(quantiteValeur>0){
                var itemPrice = getItemPrice(ItemValeur);
                var itemPriceTotal = itemPrice * quantiteValeur;

                var nouvelleItem = {
                    name :ItemValeur,
                    price : itemPrice,
                    quantity :quantiteValeur,
                    totalPrix :itemPriceTotal
                };
                shopping.push(nouvelleItem);

                modifierShopping();
                updateTotalPrice();
            }

            itemSelect = 0;
            quantiteValeur = 1;
        }

        function getItemPrice(itemName) {
            switch (itemName) {
                case "briquet":
                    return 1000;
                case "pain":
                    return 500;
                case "lait":
                    return 2000;
                default:
                    return 0;
            }
        }
       function modifierShopping() {
        var shoppingList = document.getElementById("shoppingList");
        shoppingList.innerHTML = "";

        for (var i = 0; i < shopping.length; i++) {
            var item = shopping[i];
            addItemToList(item, shoppingList);
        }
        }
        

        function addItemToList(item, shoppingList) {
            var listItem = document.createElement("li");
            listItem.textContent = item.name + " x" + item.quantity + " : " + item.totalPrix + "Ar";
            shoppingList.appendChild(listItem);
        }

        function updateTotalPrice() {
            var totalPrix = 0; 

        for (var i = 0; i < shopping.length; i++) {
        var item = shopping[i];
        totalPrix += item.totalPrix;
        }

        var totalPriceElement = document.getElementById("totalPrice");
        totalPriceElement.textContent = totalPrix + "Ar";
}

