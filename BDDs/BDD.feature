Feature:	Despatched Orders have funds Captured or Refunded depending on number of items despatched and the payment method
					In order to ensure Customers are charged the correct amount for items despatched
					As a business
					When an order is Despatched
					I want the value of any despatched items and P&P to be captured for Post Pay orders
					And any unfulfilled items to be refunded for Pre Pay orders



Scenario Outline:	Customer places a Post-Pay order on the web and the order is fully despatched
	Given a <Item quantity> item Order is placed on the Website by a customer and they pay via <Payment type>
	And feature flag in MS config for the Currency and Domain is set to <Payment Toggle>
	Then Order alias PaymentIndicator will be set to <Payment Toggle>
	When the order is fully despatched
	Then the order will be processed by <Payment Service>
	And the order value including the P&P will be captured in Adyen
	And Payment notifications will be received from Adyen in Core and the Order updated
	And Order History in MS will be updated to show the items despatched, the Order marked as Complete and any Payment Service Transaction results

	Examples:	|  Item quantity	|  Payment type	|  	Payment Service	|  	Payment Toggle	|
		        |  Single					|  Credit Card	|		Payment Service	|		False						|
		        |  Multi					|  Paypal				|		Payment Service	|		False						|
		        |  Single					|  Paypal				|		Core						|		True						|
						|  Multi					|  Credit Card	|		Core						|		True						|
