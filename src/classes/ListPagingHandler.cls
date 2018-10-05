/**
  Implement the logic to handle large lists and page through them.
**/
public with sharing class ListPagingHandler {
	public static final String NULL_MSG = 'Selections list must not be null!';
	
	private final List<CopadoMetadata> allSelections;

	// Default to 1000 rows which is the max that can be displayed in a VF datatype
	public static final Integer MAX_PAGE_SIZE = 1000;
	public final Integer pageSize {get; private set; } 
	public final Integer maxPage {get; private set; }

	// Page is 0-based index, ensure it's between 0 and maxPage
	public Integer currentPage {get;
		set { currentPage = Math.max(0,Math.min(maxPage,value)); } }

	public ListPagingHandler(List<CopadoMetadata> allSelections, Integer maxPageSize) {
		System.Assert(allSelections != null,NULL_MSG);

		System.Debug('Max Page Size input: ' + maxPageSize);
        System.Debug('MAX_PAGE_SIZE constant: ' +MAX_PAGE_SIZE);

		pageSize = Math.min(maxPageSize,MAX_PAGE_SIZE);

		this.allSelections = allSelections;

        System.Debug('Selections Size: ' + allSelections.size());
        System.Debug('PageSize: ' + pageSize);

		maxPage= Math.max(((allSelections.size()+pageSize-1)/pageSize) -1,0);  // Must set MaxPage before CurrentPage, otherwise NPE
		System.Debug('Max Page: ' + maxPage);

		currentPage=0;

	}

    /**
      Alternate Constructor that defaults the pagesize
    **/
	public ListPagingHandler(List<CopadoMetadata> allSelections) {
		this(allSelections,MAX_PAGE_SIZE);
	}

	/**
	  GetSelections for the current page
	**/
	public List<CopadoMetadata> getSelections() {
		// Short cut for small lists, just return the original list
		if (allSelections.size() <= pageSize) {
			return this.allSelections;
		} else {
			// Copy the selections that should be in this page range
            List<CopadoMetadata> selections = new List<CopadoMetadata>();
            Integer first = currentPage * pageSize;   // 0=0, 1=1000, 2=2000
            Integer last =  Math.min(first + pageSize-1,allSelections.size()-1);  // Page0=999,Page1=1999
            for (Integer i=first; i <= last; i++) {
            	selections.add(allSelections[i]);
            }
            return selections;
		}
	}

    /**
      Is there a previous page?
    **/
	public Boolean hasPrevious() {
		return this.currentPage > 0;
	}
	/**
	  Is there a next page?
	**/
	public Boolean hasNext() {
		return this.currentPage < this.maxPage;
	}

    /**
      Advance the current page
    **/
	public Integer next() {
		this.currentPage = this.currentPage + 1;
		return this.currentPage;
	}


	/**
	   Back up 1 page
	**/
	public Integer previous() {
		this.currentPage = this.currentPage -1;
		return this.currentPage;
	}

}