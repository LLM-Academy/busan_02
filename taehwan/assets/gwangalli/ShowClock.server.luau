-- A shared epoch lets late joiners see the same show schedule.
workspace:SetAttribute('GwangalliShowEpoch', workspace:GetServerTimeNow() + 12)
print('Gwangalli show clock ready')
