import logging
from google.appengine.ext import endpoints
from google.appengine.ext import ndb
from protorpc import remote
from protorpc import messages

# DB Model

class DBEntry(ndb.Model):
    """Model to store Entries into the Demo "Guestbook".

    Since the date property is auto_now_add=True, Entries will document
    when they were inserted immediately after being stored.
    """
    author = ndb.TextProperty(required=True)
    text = ndb.TextProperty(required=True)
    date = ndb.DateTimeProperty(auto_now_add=True)

    @property
    def timestamp(self):
        """Property to format a date to a JSON compatible string."""
        return self.date.strftime("%Y-%m-%dT%H:%M:%S")

    def to_message(self):
        """Turns the DBEntry entity into a ProtoRPC object.

        This is necessary so the entity can be returned in an API request.

        Returns:
            An instance of Entry.
        """

        return Entry(id=self.key.id(),
                     author=self.author,
                     text=self.text,
                     date=self.timestamp)

    @classmethod
    def put_from_message(cls, message):
        """Checks authentication and inserts a new entry.

        Args:
            message: An Entry instance to be inserted.

        Returns:
            The entry that was inserted.
        """
        current_user = endpoints.get_current_user()
        if current_user is None:
            raise endpoints.UnauthorizedException('Authentication required.')
        
        entity = cls(author=message.author, text=message.text)
        entity.put()
        return entity
        
    @classmethod
    def query_entries(cls):
        """Creates a query for all entries

        Returns:
            An ndb.Query object.
            This can be used to filter for other properties or order by them.
        """
        return cls.query()
        

# Message Classes

class EntryListRequest(messages.Message):
    class Order(messages.Enum):
        newest = 1
        oldest = 2

    maxResults = messages.IntegerField(1, default=100)
    sortOrder = messages.EnumField(Order, 2, default=Order.newest)


class Entry(messages.Message):
    """One Guestbook entry"""

    id = messages.IntegerField(1)
    author = messages.StringField(2, required=True)
    text = messages.StringField(3, required=True)
    date = messages.StringField(4)


class EntryList(messages.Message):
    """List of Guestbook entries"""
    items = messages.MessageField(Entry, 1, repeated=True)

    
# API Definition

CLIENT_ID = "817861005374.apps.googleusercontent.com"


@endpoints.api(name="gdgdemo", version="v1",
               description="GDG Endpoint Demo",
               allowed_client_ids=[CLIENT_ID, endpoints.API_EXPLORER_CLIENT_ID],
               scopes=["https://www.googleapis.com/auth/userinfo.email"])
class GDGDemoApi(remote.Service):

    @endpoints.method(EntryListRequest, EntryList,
                      path='entries', http_method='GET',
                      name='entries.list')
    def get_entry_list(self, request):
        """Request a list of Guestbook entries"""
    
        query = DBEntry.query_entries()
        if request.sortOrder == EntryListRequest.Order.oldest:
          query = query.order(DBEntry.date)
        else:
          query = query.order(-DBEntry.date)
        
        items = [entity.to_message() for entity in query.fetch(request.maxResults)]

        return EntryList(items=items)
        
    @endpoints.method(Entry, Entry,
                      path='entries/new', http_method='POST',
                      name='entries.insert',
                      scopes=["https://www.googleapis.com/auth/userinfo.email"])
    def insert_entry(self, request):
        """Insert a new entry to the database"""
    
        entity = DBEntry.put_from_message(request)
       
        return entity.to_message()


# Initialize the API Service
application = endpoints.api_server([GDGDemoApi], restricted=False)


