public abstract with sharing class BasePagingController {
	// This controls the number of rows per page
	public static final Integer DEFAULT_PAGESIZE = 25;
	
	// Would have preferred to make this final, but can't because we can't create it before the context is set
	private ListPagingHandler handler;

    public Integer pageSize {
       get { return handler.pageSize; }
    }

    public Integer currentPage { 
                    get { return handler.currentPage; } 
                    set { handler.currentPage=value;} 
                }

    public Integer maxPage { 
                    get { return handler.maxPage; } 
                }

    public Boolean hasNext {
        get { return handler.hasNext(); }
    }

    public Boolean hasPrevious {
    	get { return handler.hasPrevious(); }
    }

    public PageReference next() {
         handler.next();
         return null;
    }

    public PageReference previous() {
         handler.previous();
         return null;
    }

    /**
      Implementing Classes may call this from their constructor if the state is known at that time.
    **/
    public void initHandler() {

    	handler = new ListPagingHandler(UserStoryCommitUtil.getGitMetadataSelections(initHandlerArgs()),DEFAULT_PAGESIZE);

    }

    /**
      Git Metadata Selections are stored in JSON in a Attachment on the Snapshot commit
      Get the Selections using the Handler.  The handler has been initialized to the correct User Story list as scope.
    **/
    public List<CopadoMetadata> getGitMetadataSelections() {
    	if (handler == null) {
    		initHandler();
    	}

    	return handler.getSelections();
    }


    /**
       Subclasses implement this method to establish the User Stories that are used to initialize the handler
       Expected that the ID's belong to User Stories relevant to whatever scope this is being used in.
    **/
    protected abstract List<Id> initHandlerArgs();
}