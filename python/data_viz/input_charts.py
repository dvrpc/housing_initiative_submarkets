import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd


dataset = pd.read_csv(
    "U:\\FY2022\\Planning\\RegionalHousingInitiative\\SubmarketAnalysis\\data\\LPA_Test2_Submarkets\\lpa_results_2_submarkets.csv",
    index_col=0
)
print(dataset)


sns.boxplot(data=dataset, x="Class", y="HHINC_MED", palette="pastel", orient="v", dodge="False")
plt.ylim(0, 300000)
plt.ticklabel_format(style='plain', axis='y')

plt.show()

