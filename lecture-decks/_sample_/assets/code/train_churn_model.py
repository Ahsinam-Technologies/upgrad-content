from sklearn.compose import ColumnTransformer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

features = ["monthly_spend", "tenure_months", "support_tickets", "plan"]
preprocess = ColumnTransformer([
    ("numeric", StandardScaler(), features[:3]),
    ("category", OneHotEncoder(handle_unknown="ignore"), ["plan"]),
])
model = Pipeline([
    ("prepare", preprocess),
    ("classifier", LogisticRegression(max_iter=1_000)),
])
model.fit(train[features], train["churned"])
churn_probability = model.predict_proba(customer[features])[:, 1]
