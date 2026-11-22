// Requête Prets (vue MySQL v_loan_360 : 682 lignes, un prêt par ligne).
// Script de référence : l'original se trouve dans le fichier .pbix (Éditeur avancé).
// Les colonnes est_termine, est_difficulte et description_statut conservent le type d'origine.
let
    Source = MySQL.Database("127.0.0.1", "berka"),
    Vue = Source{[Schema = "berka", Item = "v_loan_360"]}[Data],
    Renommee = Table.RenameColumns(Vue, {
        {"loan_id", "id_pret"},
        {"account_id", "id_compte"},
        {"loan_date", "date_pret"},
        {"loan_amount", "montant_pret"},
        {"duration_months", "duree_mois"},
        {"monthly_payment", "mensualite"},
        {"loan_status", "statut_pret"},
        {"loan_status_description", "description_statut"},
        {"is_finished", "est_termine"},
        {"is_problem", "est_difficulte"},
        {"account_opened_date", "date_ouverture_compte"},
        {"district_id", "id_district"},
        {"district_name", "nom_district"},
        {"owner_client_id", "id_client_titulaire"},
        {"owner_gender", "sexe_titulaire"},
        {"owner_birth_date", "date_naissance_titulaire"},
        {"owner_age_at_loan", "age_titulaire_au_pret"}
    }),
    Types = Table.TransformColumnTypes(Renommee, {
        {"id_pret", Int64.Type},
        {"id_compte", Int64.Type},
        {"date_pret", type date},
        {"montant_pret", Currency.Type},
        {"duree_mois", Int64.Type},
        {"mensualite", Currency.Type},
        {"date_ouverture_compte", type date},
        {"id_district", Int64.Type},
        {"id_client_titulaire", Int64.Type},
        {"date_naissance_titulaire", type date},
        {"age_titulaire_au_pret", Int64.Type}
    }),
    // Variable dérivée : tranche d'âge au moment du prêt (préfixes numériques pour l'ordre d'affichage).
    AvecTranche = Table.AddColumn(Types, "tranche_age", each
        if [age_titulaire_au_pret] < 30 then "1. Moins de 30 ans"
        else if [age_titulaire_au_pret] < 40 then "2. 30-39 ans"
        else if [age_titulaire_au_pret] < 50 then "3. 40-49 ans"
        else "4. 50 ans et plus", type text)
in
    AvecTranche
