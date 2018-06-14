Feature: Despatched Orders have funds Captured or Refunded depending on number of items despatched and the payment method
	 In order to ensure Customers are charged the correct amount for items despatched
	 As a business
	 When an order is Despatched
	 I want the value of any despatched items and P&P to be captured for Post Pay orders
	 And any unfulfilled items to be refunded for Pre Pay orders



Scenario Outline: Customer places a Post-Pay order on the web and the order is fully despatched
	Given a <Item quantity> item Order is placed on the Website by a customer and they pay via <Payment type>
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully despatched
	Then the order will be processed by <Payment Service>
	And the order value including the P&P will be captured in Adyen
	And Capture Payment notifications will be received from Adyen in Core and the Order updated
	And AWS Order History will be updated to show the items despatched, the Order marked as Complete and any Payment Service Transactions

	Examples:	|  Item quantity	|  Payment type	|  	Payment Service	|  	Payment Toggle	|
		        |  Single		|  Credit Card	|	Payment Service	|	False		|
		        |  Multi		|  Paypal	|	Payment Service	|	False		|
		        |  Single		|  Paypal	|	Core		|	True		|
			|  Multi		|  Credit Card	|	Core		|	True		|


Scenario Outline: Customer places a Pre-Pay APM order on the web and the order is fully despatched
	Given a <Item quantity> item Order is placed on the Website by a customer and they pay with an APM (iDeal, Giropay)
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully despatched
	Then the order will be processed by <Payment Service>
	And as order is pre pay and is fully despatched no requests should be sent to Adyen
	And AWS Order History will be updated to show the items despatched and the Order marked as Complete

	Examples:	|  Item quantity	|  	Payment Service	|  	Payment Toggle	|
			|  Single		|	Payment Service	|	False		|
			|  Multi		|	Payment Service	|	False		|
			|  Multi		|	Core		|	True		|


Scenario Outline: Customer places a web order in Store and the order is fully despatched
	Given a <Item quantity> item Order is placed by a customer in Store
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully despatched
	Then despite indicating the order will be processed by <Payment Service> as order is Store Order no requests should be sent to Adyen
	And AWS Order History will be updated to show the items despatched and the Order marked as Complete

	Examples:	|  Item quantity	|  	Payment Service	|  	Payment Toggle	|
			|  Single		|	Payment Service	|	False		|
			|  Multi		|	Payment Service	|	False		|
			|  Multi		|	Core		|	True		|


Scenario Outline: Customer places a Post-Pay order on the Phone App and the order is fully despatched
	Given a <Item quantity> item Order is placed by a customer on the Mobile Phone App and they pay via <Payment type>
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully despatched
	Then the order will be processed by <Payment Service>
	And the order value including the P&P will be captured in Adyen
	And Capture Payment notifications will be received from Adyen in Core and the Order updated
	And AWS Order History will be updated to show the items despatched, the Order marked as Complete and any Payment Service Transactions

	Examples:	|  Item quantity	|  Payment type	|  	Payment Service	|  	Payment Toggle	|
			|  Single		|  Credit Card	|	Payment Service	|	False		|
			|  Multi		|  Paypal	|	Payment Service	|	False		|
		        |  Single		|  Paypal	|	Core		|	True		|
			|  Multi		|  Credit Card	|	Core		|	True		|


Scenario Outline: Customer places a Post-Pay order on the web but the order is only partially despatched
	Given a multi item Order is placed on the Website by a customer and they pay via <Payment type>
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is only partially despatched
	Then the order will be processed by <Payment Service>
	And only the value of items despatched including the P&P will be captured in Adyen
	And Capture Payment notifications will be received from Adyen in Core and the Order updated
	And AWS Order History will be updated to show the items despatched and cancelled, the Order marked as Complete and any Payment Service Transactions

	Examples:	|  Payment type	|  	Payment Service	|  	Payment Toggle	|
			|  Credit Card	|	Payment Service	|	False		|
			|  Paypal	|	Payment Service	|	False		|
			|  Credit Card	|	Core		|	True		|
			|  Paypal	|	Core		|	True		|


Scenario Outline: Customer places a Pre-Pay APM order on the web but the order is only partially despatched
	Given a multi item Order is placed on the Website by a customer and they pay via an APM (iDeal, Giropay, Sofort)
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is only partially despatched
	Then the order will be processed by <Payment Service>
	And the value of unfulfilled items will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen in Core and the Order updated
	And AWS Order History will be updated to show the items despatched and cancelled, the Order marked as Complete and any Payment Service Transactions

	Examples:	|	Payment Service	|  	Payment Toggle	|
			|	Payment Service	|	False		|
			|	Core		|	True		|


Scenario Outline: Customer places a web order in Store and the order is only partially despatched
	Given a multi item Order is placed by a customer in Store
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is only partially despatched
	Then despite indicating the order will be processed by <Payment Service> as order is Store Order no requests should be sent to Adyen
	And an email will be generated for the Profit Protection team to refund to the customer the value of the unfulfilled items
	And AWS Order History will be updated to show the items despatched and cancelled and the Order marked as Complete

	Examples:	|  	Payment Service	|  	Payment Toggle	|
			|	Payment Service	|	False		|
			|	Core		|	True		|


Scenario Outline: Customer places a Post-Pay order on the Phone App and the order is only partially despatched
	Given a multi item Order is placed by a customer on the Mobile Phone App and they pay via <Payment type>
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is only partially despatched
	Then the order will be processed by <Payment Service>
	And only the value of items despatched including the P&P will be captured in Adyen
	And Payment notifications will be received from Adyen in Core and the Order updated
	And AWS Order History will be updated to show the items despatched and cancelled, the Order marked as Complete and any Payment Service Transactions

	Examples:	|  Payment type	|  	Payment Service	|	Payment Toggle	|
			|  Credit Card	|	Payment Service	|	False		|
			|  Paypal	|	Payment Service	|	False		|
			|  Credit Card	|	Core		|	True		|
		       	|  Paypal	|	Core		|	True		|


Scenario Outline: Customer places a Post-Pay order on the web, Pre Deploy, but the order is partially despatched Post Deploy
	Given a multi item Order is placed on the Website by a customer before OPD Phase 2 has been deployed and they pay via <Payment type>
	And then OPD Phase 2 is deployed
	Then Orderalias PaymentIndicator will be blank
	When the order is partially despatched
	Then the order will be processed by Core
	And only the value of items despatched including the P&P will be captured in Adyen
	And Payment notifications will be received from Adyen in Core and the Order updated

	Examples:	|  Payment type	|
		        |  Credit Card	|
			|  Paypal	|


Scenario: Customer places a Pre-Pay APM order on the web, Pre Deploy, but the order is partially despatched Post Deploy
	Given a multi item Order is placed on the Website by a customer before OPD Phase 2 has been deployed and they pay with an APM (iDeal, Giropay)
	And then OPD Phase 2 is deployed
	Then Orderalias PaymentIndicator will be blank
	When the order is partially despatched
	Then the order will be processed by Core
	And the value of unfulfilled items will be refunded in Adyen
	And Payment notifications will be received from Adyen in Core and the Order updated


Scenario: Customer places a web order in Store, Pre Deploy, but the order is partially despatched Post Deploy
	Given a multi item Order is placed by a customer in Store before OPD Phase 2 deployed
	And then OPD Phase 2 is deployed
	Then Orderalias PaymentIndicator will be blank
	When the order is partially despatched
	Then an email will be generated for the Profit Protection team to refund to the customer the value of the unfulfilled items


Scenario: Customer places a web order, Pre Deploy, but the order is despatched Post Deploy with PaymentIndicator False
	Given a multi item Order is placed on the Website by a customer before OPD Phase 2 has been deployed and they pay with Credit Card
	Then no AWS Order History will exist
	And then OPD Phase 2 is deployed
	And PaymentIndicator is manually overridden to False
	Then Orderalias PaymentIndicator will be False
	When the order is despatched
	Then there will be an error raised in MS as No Order history exists and Event cannot be passed onto Payment Service team


***The above scenarios will be placed using different Domains and Currencies to ensure coverage.

***Will need Item and P&P Promos applied to some of these orders

***Customer emails will be generated for all events

***ADRA & IntelliQ checks required

***GL Validation required
