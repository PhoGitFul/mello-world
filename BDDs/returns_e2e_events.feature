Feature: Returned Orders have payments Refunded
	 In order to ensure Customers are refunded for returned items
	 As a business
	 When Returned items are accepted items by the business
	 I want the value of returned items including any P&P due to be refunded back to the customer



Scenario Outline: Customer Partially returns an order which was placed on the web
	Given a multi item order was placed on the Website, paid via <Payment type> and partially despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is partially returned as a <Return Reason> return
	Then the refund will be processed by <Payment Service>
	And the value of the returned items will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the items are Returned, the Reason Code and any Payment Service Transactions

	Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|	Return reason	|
			|  Credit Card	|	Payment Service	|	False			|	Saleable	|
			|  Paypal	|	Payment Service	|	False			|	CBR		|
			|  APM		|	Payment Service	|	False			|	Damaged		|
			|  Credit Card	|	Core		|	True			|	Mispick		|
			|  Paypal	|	Core		|	True			|	Damaged		|
			|  APM		|	Core		|	True			|	Saleable	|


Scenario Outline: Customer Partially returns an order which was placed in Store
	Given a multi item order was placed in Store and partially despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is partially returned as a <Return Reason> return
	Then an email will be generated for the Profit Protection team to refund to the customer the value of the returned items
	And the order will be updated in Core
	And AWS Order History will be updated to show the items are Returned and the Reason & Return Codes

	Examples:	|	Payment Indicator	|  Return reason	|
		        |	False			|  Saleable		|
		        |	True			|  Damaged		|


Scenario Outline: Customer Fully returns an order which was placed on the web and qualifies for P&P Refund
	Given a multi item order was placed on the Website, paid via <Payment type> and successfully despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully returned with return reasons of Saleable, Damaged, Mispick or CBR
	Then the refund will be processed by <Payment Service>
	And the value of the returned items and P&P will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the Shipping & items are fully Returned, the Reason Code and any Payment Service Transactions

	Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|
			|  Credit Card	|	Payment Service	|	False			|
			|  Paypal	|	Payment Service	|	False			|
			|  APM		|	Payment Service	|	False			|
			|  Credit Card	|	Core		|	True			|
			|  Paypal	|	Core		|	True			|
			|  APM		|	Core		|	True			|


Scenario Outline: Customer Fully returns an order which was placed on the web and but does not qualify for P&P Refund
	Given a multi item order was placed on the Website, paid via <Payment type> and successfully despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully returned with at least one item returned as a Customer Service Return
	Then the refund will be processed by <Payment Service>
	And the value of the returned items (apart from Cust Serv Return item) will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the items (apart from Cust Serv Return item) are Returned, the Reason Code and any Payment Service Transactions

	Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|
			|  Credit Card	|	Payment Service	|	False			|
			|  Paypal	|	Payment Service	|	False			|
			|  APM		|	Payment Service	|	False			|
			|  Credit Card	|	Core		|	True			|
			|  Paypal	|	Core		|	True			|
			|  APM		|	Core		|	True			|


Scenario Outline: Customer Fully returns an order which was placed in Store and qualifies for P&P refund
	Given a multi item order was placed in Store and partially despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully returned with return reasons of Saleable, Damaged or Mispick
	Then an email will be generated for the Profit Protection team to refund to the customer the value of the whole order (items and P&P)
	And the order will be updated in Core
	And AWS Order History will be updated to show the Shipping & items are fully Returned and the Reason & Return Codes

	Examples:	|	Payment Indicator	|
		        |	True			|
			|	False			|


Scenario Outline: Customer Fully returns an order which was placed in Store but does not qualify for P&P refund
	Given a multi item order was placed in Store and successfully despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully returned with at least one item returned as a Customer Service Return
	Then an email will be generated for the Profit Protection team to refund to the customer the value of the returned items (apart from Cust Serv Return item)
	And the order will be updated in Core
	And AWS Order History will be updated to show the items are Returned (apart from Cust Serv Return item) and the Reason & Return Codes

	Examples:	|	Payment Indicator	|
		        |	True			|
			|	False			|


Scenario Outline: Customer Fully returns an order which was placed on the Phone App
	Given a multi item order was placed on the Phone App, paid via <Payment type> and partially despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully returned with return reasons of Saleable, Damaged, Mispick or CBR
	Then the refund will be processed by <Payment Service>
	And the value of the returned items and P&P will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the Shipping & items are fully Returned, the Reason Code and any Payment Service Transactions

	Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|
			|  Credit Card	|	Payment Service	|	False			|
			|  Paypal	|	Core		|	True			|


Scenario Outline: Customer partially returns an order which was placed when DataCash was the Payment Provider and Core is Payments processor
	Given an old old order was placed on the web, paid via <Payment type> and despatched
	And PaymentIndicator is manually overridden to False
	Then Orderalias PaymentIndicator will be False
	When an item on the order is returned with return reasons of either Saleable, Damaged, Mispick or CBR
	Then an email will be generated in Core for the Profit Protection team to refund to the customer the value of the returned items
	Then Core and will likely just write to PBL tables and fail in Datacash
	And the order will be updated in Core

	Examples:	|  Payment type	|
			|  Credit Card	|
			|  Paypal	|


Scenario Outline: Customer partially returns an order which was placed when DataCash was the Payment Provider and Payment Service is Payments processor
	Given an old old order was placed on the web, paid via <Payment type> and despatched
	And PaymentIndicator is manually overridden to True
	Then Orderalias PaymentIndicator will be True
	When an item on the order is returned with return reasons of either Saleable, Damaged, Mispick or CBR
	Then an email will be generated in Core for the Profit Protection team to refund to the customer the value of the returned items
	And the order will be updated in Core
	And the refund will also be attempted to be processed by Payment Service, will fail and probably raise an error

	Examples:	|  Payment type	|
		        |  Credit Card	|
			|  Paypal	|


Scenario Outline: Customer Fully returns an order which was placed on the web before deploy
	Given a multi item order was placed on the Website, Pre OPD Phase 2 deploy, paid via <Payment type> and partially despatched
	And then OPD Phase 2 is deployed
	Then Orderalias PaymentIndicator will be blank
	When the order is fully returned with return reasons of either Saleable, Damaged, Mispick or CBR
	Then the refund will be processed by Core
	And the value of the returned items and P&P will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core

	Examples:	|  Payment type	|
		        |  Credit Card	|
			|  Paypal	|
			|  APM		|


Scenario: Customer Fully returns an order which was placed in Store before deploy
	Given a multi item order was placed in Store, Pre OPD Phase 2 deploy, and partially despatched
	And then OPD Phase 2 is deployed
	Then Orderalias PaymentIndicator will be blank
	When the order is fully returned with return reasons of either Saleable, Damaged, Mispick or CBR
	Then an email will be generated for the Profit Protection team to refund to the customer the value of the order
	And the order will be updated in Core



Feature: RICC refunded items trigger refunds to the Customer
	 In order to ensure Customers are refunded for RICC refunded items
	 As a business
	 When RICC Processes refunds on an Order
	 I want the value of refunded items or P&P to be refunded back to the customer


Scenario Outline: Customer returns an item in a dubious condition back to the DC but after inspection the return is accepted and refund is processed by RICC
	Given a multi item order was placed on the Website, paid via <Payment type> and successfully despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When an item on the order is refunded in RICC
	Then the refund will be processed by <Payment Service>
	And the value of the returned item will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the item is Returned, the Reason Code and any Payment Service Transactions

Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|
		|  Credit Card	|	Payment Service	|	False			|
		|  Paypal	|	Payment Service	|	False			|
		|  APM		|	Payment Service	|	False			|
		|  Credit Card	|	Core		|	True			|
		|  Paypal	|	Core		|	True			|
		|  APM		|	Core		|	True			|


Scenario Outline: Customer complains to Customer Service team about late delivery of an order and they decide to refund the Shipping on that order
	Given a multi item order was placed on the Website, paid via <Payment type> and successfully despatched
	And feature flag in MS config for the Site and Payment Provider is set to <Payment Toggle>
	Then Orderalias PaymentIndicator will be set to <Payment Toggle>
	When the Shipping on the order is refunded in RICC
	Then the refund will be processed by <Payment Service>
	And the value of the P&P will be refunded in Adyen
	And Refund Payment notifications will be received from Adyen and order & EFT updated in Core
	And AWS Order History will be updated to show the P&P is Returned, the Reason Code and any Payment Service Transactions


Examples:	|  Payment type	|	Payment Service	|	Payment Indicator	|
		|  Credit Card	|	Payment Service	|	False			|
		|  Paypal	|	Payment Service	|	False			|
		|  APM		|	Payment Service	|	False			|
		|  Credit Card	|	Core		|	True			|
		|  Paypal	|	Core		|	True			|
		|  APM		|	Core		|	True			|


Scenario: Customer places a web order, Pre Deploy, but the order is returned Post Deploy with PaymentIndicator False
	Given a multi item order was placed on the Website by a customer before OPD Phase 2 has been deployed and they paid with Credit Card and it was successfully despatched
	Then no AWS Order History will exists
	And then OPD Phase 2 is deployed
	And PaymentIndicator is manually overridden to False
	Then Orderalias PaymentIndicator will be False
	When the order is returned
	Then there will be an error raised in MS as No Order history exists and Event cannot be passed onto Payment Service team


***The above scenarios will be placed using different Domains and Currencies to ensure coverage.

***Customer emails will be generated for all events

***ADRA & IntelliQ checks required

***GL Validation required
