Process followed:-

we were provided with 2 relations Organisation and Call_Log, in the Organisation table there was a column named Properties the data there was is in JSON
format so i thought we should exctract the data from that column and make a separate relation with it and form parent-child relation with Organisation relation.

Hence i wrote a python script to extract the data from the Properties column and now we have 3 sheets i.e Organisation,Call_Log and Properties.

Also using SQLAlchemy i have transfered the data into the POSTGRESQL database.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


INSIGHTS:

-The first connected from all of the renewed organisation's from GUJRAT location is connected through COMPANY R.

-The count of organisation that had 3 consecutive calls with in 0-4 days renewed(1), non-renewed(4)
						      5-8 days renewed(3), non-renewed(3)
					                       9-15 days renewed(2), non-renewed(1)
                                                                                                           16-30 days renewed(3), non-renewed(1)
					                       30+ days   renewed(10), non-renewed(8)

-The location with maximum no. of connected-calls for unique leads  are-
For lead-id "0a8c5c37-7b19-4949-9b35-d5a39c9491cc" call count was 2 for Punjab location
For lead-id "c2c7b68c-bc4e-430f-87b9-b4aba6aa38d0" call count was 2 for Maharastra Location
For lead-id "da6e191c-ef2b-4e58-b09d-c09e1deeb2fd" call count was 2 for Gujrat Location

These were the top 3 locations for unique leads

-The most common reason for why the call was not connected was dur to the call was NOT-PICKED by the customer.