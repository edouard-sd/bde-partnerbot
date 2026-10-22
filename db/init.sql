-- BDE PartnerBot - schema de la base metier (contacts_bde)
-- Execute automatiquement par Postgres au premier demarrage (volume vide).

CREATE TABLE IF NOT EXISTS public.contacts (
    id                      SERIAL PRIMARY KEY,
    email                   VARCHAR(255) NOT NULL UNIQUE,
    nom                     VARCHAR(255) NOT NULL,
    entreprise              VARCHAR(255) DEFAULT 'N/A',
    linkedin_id             VARCHAR(255),
    produit_interesse       VARCHAR(255) DEFAULT 'notre solution',
    statut                  VARCHAR(50)  DEFAULT 'nouveau',
    mail_genere             TEXT,
    mail_sujet              VARCHAR(500),
    nombre_relances         INTEGER DEFAULT 0,
    erreur_message          TEXT,
    reponse_date            TIMESTAMP,
    reponse_body            TEXT,
    date_creation           TIMESTAMP DEFAULT NOW(),
    date_premier_contact    TIMESTAMP,
    date_mail_envoye        TIMESTAMP,
    date_derniere_relance   TIMESTAMP,
    date_derniere_tentative TIMESTAMP,
    updated_at              TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contacts_email   ON public.contacts (email);
CREATE INDEX IF NOT EXISTS idx_contacts_statut  ON public.contacts (statut);
CREATE INDEX IF NOT EXISTS idx_relance_eligible ON public.contacts (statut, nombre_relances, date_derniere_relance DESC)
    WHERE nombre_relances < 3;

CREATE TABLE IF NOT EXISTS public.support_tickets (
    id             SERIAL PRIMARY KEY,
    prospect_email VARCHAR(255),
    subject        VARCHAR(500),
    body           TEXT,
    from_header    VARCHAR(500),
    thread_id      VARCHAR(255),
    message_id     VARCHAR(255),
    status         VARCHAR(50) DEFAULT 'new',
    created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.error_log (
    id            SERIAL PRIMARY KEY,
    workflow_name TEXT,
    node_name     TEXT,
    error_message TEXT,
    execution_id  TEXT,
    execution_url TEXT,
    created_at    TIMESTAMP DEFAULT NOW()
);

-- Contact de demonstration (remplacer l'email par une adresse de test que vous controlez)
INSERT INTO public.contacts (email, nom, entreprise, produit_interesse)
VALUES ('prospect.demo@example.com', 'Jean Test', 'Decathlon', 'dotation de materiel sportif')
ON CONFLICT (email) DO NOTHING;
