# Tp CryptoApp

### Fonctionnalités opérationnelles
- Ouverture par reconnaissance d'empreinte digitale si appareil compatible
- Inscription et attribution d'un identifiant unique aléatoire
- Envoi de message chiffré à un utilisateur avec la fonction native "SecKeyEncrypt"
(https://developer.apple.com/reference/security/1617956-seckeyencrypt)
- Consultation du dernier message envoyé

### Vues non fonctionnelles
- Contacts
- Paramètres

### Tester l'application
- Lancer le serveur API Tp-CryptoApi (https://github.com/guinicarjo/Tp-CryptoApi)
- Lancer deux simulateurs avec le projet Tp-CryptoApp (https://github.com/guinicarjo/Tp-CryptoApp)
voir (http://stackoverflow.com/questions/26446346/xcode6-run-two-instances-of-the-simulator)
- S'inscrire sur chacuns des appareils (utilisateur A, utilisateur B)
- sur l'appareil A : envoyer un message à B
- sur l'appareil B : consulter le message de A

### Détails du fonctionnement
- A la création d'un compte, une paire de clés public/privée est générée
- Au login un token JWT assure que l'utilisateur est bien enregistré côté serveur pour le reste des opérations.
- La clé public est encodée en base 64 et envoyée avec le nom d'utilisateur et le mot de passe en base de donnée.
- A l'envoi d'un message, la clé public du destinataire permet de chiffrer le message.
- Le message chiffré, le destinataire et l'expediteur sont enregistrés en base de donnée.
- Lorsqu'un utilisateur consulte son message, ce dernier est déchiffré avec sa clé privée stockée dans l'appareil.

### Reste à faire
- Signature des messages
- Vérification de l'authenticité des messages
- Controles des entrées formulaire (mot de passe fort, chaines vides, failles XSS, etc...)
- Gestion de contacts
- Exploitation de la base de contacts de l'appareil
- Paramètres divers (changement de mot de passe, délais de destruction des messages)
- Détails d'ergonomie fonctionnelle (liste des destinataires dans le champ message, messages d'erreur)
- Page infos et mentions légales
