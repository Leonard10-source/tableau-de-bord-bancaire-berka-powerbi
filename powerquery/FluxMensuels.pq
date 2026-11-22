// Requête FluxMensuels (vue MySQL v_monthly_flows : 72 lignes, un mois par ligne, 1993-1998).
// Script de référence : l'original se trouve dans le fichier .pbix (Éditeur avancé).
let
    Source = MySQL.Database("127.0.0.1", "berka"),
    Vue = Source{[Schema = "berka", Item = "v_monthly_flows"]}[Data],
    Renommee = Table.RenameColumns(Vue, {
        {"transaction_year", "annee"},
        {"transaction_month", "mois"},
        {"year_month", "annee_mois"},
        {"transaction_count", "nb_transactions"},
        {"active_accounts", "comptes_actifs"},
        {"inflows", "entrees"},
        {"outflows", "sorties"},
        {"net_flow", "flux_net"}
    }),
    Types = Table.TransformColumnTypes(Renommee, {
        {"annee", Int64.Type},
        {"mois", Int64.Type},
        {"nb_transactions", Int64.Type},
        {"comptes_actifs", Int64.Type},
        {"entrees", Currency.Type},
        {"sorties", Currency.Type},
        {"flux_net", Currency.Type}
    }),
    // Premier jour du mois : clé de la relation avec DimCalendrier[Date].
    AvecMois = Table.AddColumn(Types, "mois_debut", each #date([annee], [mois], 1), type date)
in
    AvecMois
