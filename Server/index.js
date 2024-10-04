const express = require("express");
const app = express();

const Stripe = require("stripe");
const stripe = Stripe(
  "sk_test_51Q54us1eF96NaYsOBjo1aEDqx5vj0pIna9L0jKTaUMP1D4TMQJl23QS6xmqvjcfXBrncvlfaV6jZD1uNx7ilvOrw00PBCeJDvU"
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Root endpoint to check server status
app.get("/", (req, res) => {
  res.send("Hello, welcome to the Stripe Payment API.");
});

// Payment API using Stripe
app.post("/api/payment", async (req, res) => {
  const { amount, currency } = req.body;

  try {
    // Create a payment intent
    const paymentIntent = await stripe.paymentIntents.create({
      automatic_payment_methods: {
        enabled: true,
      },
      amount: 2000, // Amount in smallest currency unit (e.g., cents)
      currency: 'usd', // Currency (e.g., 'usd')
    });

    // Check payment status and return client secret for frontend confirmation

    console.log(paymentIntent.status);
    if (paymentIntent.status !== "succeeded") {
      return res.status(200).json({
        message: "Please confirm the payment",
        client_secret: paymentIntent.client_secret, // Send this to frontend for payment confirmation
      });
    }

    // If the payment was successful
    return res.status(200).json({
      message: "Payment successful",
    });
  } catch (error) {
    console.error("Error creating payment intent:", error);
    return res.status(500).json({
      message: "Payment failed",
      error: error.message,
    });
  }
});

// Start the server
app.listen(5050, () => console.log("Server running on port 5050"));
