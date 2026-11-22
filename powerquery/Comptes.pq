// Requête Comptes (vue MySQL v_account_summary : 4 500 lignes, un compte par ligne).
// Script de référence : l'original se trouve dans le fichier .pbix (Éditeur avancé).
// La fonction M s'écrit MySQL.Database (casse respectée).
let
    Source = MySQL.Database("127.0.0.1", "berka"),
    Vue = Source{[Schema = "berka", Item = "v_account_summary"]}[Data],
    Renommee = Table.RenameColumns(Vue, {
        {"account_id", "id_compte"},
        {"opened_date", "date_ouverture"},
        {"account_frequency", "frequence_compte"},
        {"district_id", "id_district"},
        {"district_name", "nom_district"},
        {"owner_client_id", "id_client_titulaire"},
        {"owner_gender", "sexe_titulaire"},
        {"transaction_count", "nb_transactions"},
        {"total_inflows", "total_entrees"},
        {"total_outflows", "total_sorties"},
        {"first_transaction_date", "date_premiere_transaction"},
        {"last_transaction_date", "date_derniere_transaction"},
        {"loan_count", "nb_prets"},
        {"problem_loan_count", "nb_prets_difficulte"},
        {"total_loan_amount", "montant_total_prets"},
        {"standing_order_count", "nb_ordres_permanents"}
    }),
    Types = Table.TransformColumnTypes(Renommee, {
        {"id_compte", Int64.Type},
        {"date_ouverture", type date},
        {"id_district", Int64.Type},
        {"id_client_titulaire", Int64.Type},
        {"nb_transactions", Int64.Type},
        {"total_entrees", Currency.Type},
        {"total_sorties", Currency.Type},
        {"date_premiere_transaction", type date},
        {"date_derniere_transaction", type date},
        {"nb_prets", Int64.Type},
        {"nb_prets_difficulte", Int64.Type},
        {"montant_total_prets", Currency.Type},
        {"nb_ordres_permanents", Int64.Type}
    })
in
    Types
