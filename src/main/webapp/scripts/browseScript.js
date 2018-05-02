function search() {
    // Declare variables
    var input, i, item,x;
    input = document.getElementById("searchText").value.toUpperCase();
    items = document.getElementsByClassName("list-group-item");
    // Loop through all list items, and hide those who don't match the search query

    for(i = 0; i < items.length; i++){
    	item = items[i].innerHTML.toUpperCase();
    	if(item.indexOf(input) == -1){
    		items[i].style.display = "none";
    	}else{
    		items[i].style.display = "";
    	}
    }
}