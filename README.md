# Spline_VS_Autocorrélation

Demonstration de l'impacte d'une dépendance temporelle sur une estimation de tendance par spline_Objectif : montrer, dans des expériences contrôlées et reproductibles, comment la prise en compte de l’autocorrélation peut améliorer la sélection du lissage, l’estimation du signal et l’évaluation de l’incertitude. \# La danse entre splines et autocorrélation

**Une démonstration interactive en R/Shiny sur le lissage statistique, la dépendance temporelle et le choix du paramètre** $\lambda$.

## Démonstration en ligne

[**Accéder à l'application Shiny**]([REMPLACER_PAR_URL_PUBLIQUE](https://01a1653a-3d22-eb01-cddc-ee9ca5eb3f16.share.connect.posit.cloud))

Remplacer cette URL par celle fournie par l'hébergeur après publication. Une adresse comme `http://127.0.0.1:7870` fonctionne uniquement sur l'ordinateur qui exécute l'application.

## Objectif scientifique

Comment retrouver un signal inconnu lorsque les observations sont bruitées et que les erreurs sont autocorrélées ?

Ce projet étudie l'influence de la dépendance temporelle sur :

-   le choix du paramètre de lissage $\lambda$ ;
-   le risque quadratique de l'estimation ;
-   les méthodes de sélection : LOO, GCV, K-fold, AIC/BIC et REML ;
-   les intervalles d'incertitude ;
-   le temps de calcul et le coût des méthodes de validation croisée.

Les méthodes sont comparées par simulation. L'objectif est d'évaluer leurs performances, et non de supposer qu'une méthode donnée échoue dans tous les cas.

## Modèle statistique

On observe :

$$
y_t=f(t)+\varepsilon_t,\quad t=1,\ldots,n.
$$

Le signal $f(t)$ est inconnu. Pour commencer, le bruit suit un processus AR(1) :

$$
\varepsilon_t=\phi\varepsilon_{t-1}+\eta_t,
\qquad |\phi|<1,
$$

où $\eta_t$ est un bruit blanc.

## Estimation par spline pénalisée

On représente le signal par une base de fonctions :

$$
f(t)\approx\sum_{j=1}^{p}\beta_j B_j(t).
$$

L'estimateur minimise un compromis entre fidélité aux données et régularité :

$$
\widehat{\boldsymbol\beta}_\lambda
=\arg\min_{\boldsymbol\beta}
\left\{
(\mathbf y-X\boldsymbol\beta)^\top W
(\mathbf y-X\boldsymbol\beta)
+\lambda\boldsymbol\beta^\top S\boldsymbol\beta
\right\}.
$$

-   $X$ contient les fonctions de base spline.
-   $W$ représente la pondération liée au modèle d'erreur.
-   $S$ représente la pénalité.
-   $\lambda$ contrôle le niveau de lissage.

Un petit $\lambda$ autorise une courbe plus flexible ; un grand $\lambda$ pénalise davantage les variations.

## Sensibilité au paramètre de lissage

Pour $W$ fixé, posons :

$$
A_\lambda=X^\top WX+\lambda S.
$$

Lorsque $A_\lambda$ est inversible :

$$
\widehat{\boldsymbol\beta}_\lambda
=A_\lambda^{-1}X^\top W\mathbf y.
$$

Sa dérivée est :

$$
\frac{\partial\widehat{\boldsymbol\beta}_\lambda}
{\partial\lambda}
=-A_\lambda^{-1}S\widehat{\boldsymbol\beta}_\lambda.
$$

Cette expression décrit comment les coefficients de la spline évoluent avec la pénalisation. Si $W$ dépend lui-même des paramètres estimés, une dérivation complète doit prendre cette dépendance en compte.

## Le risque oracle

Dans les simulations, le signal vrai est connu. On peut calculer :

$$
R(\lambda)=\frac1n\sum_{t=1}^{n}
\left[\widehat f_\lambda(t)-f(t)\right]^2
$$

et définir :

$$
\lambda^\star=\arg\min_{\lambda>0}R(\lambda).
$$

Ce paramètre oracle sert de référence dans les expériences simulées. Il n'est pas directement disponible pour des données réelles, où le signal vrai est inconnu.

## Incertitude sur lambda

Il faut distinguer le paramètre oracle $\lambda^\star$, le paramètre sélectionné $\widehat\lambda$ et la variabilité de ce dernier d'un échantillon à l'autre.

Un bootstrap paramétrique peut étudier la distribution de $\log(\widehat\lambda)$. La qualité de l'intervalle obtenu doit être vérifiée par simulation ; un intervalle bootstrap n'offre pas automatiquement une couverture correcte.

## Coût computationnel

Pour une grille de $L$ valeurs de $\lambda$, une validation K-fold classique peut nécessiter environ $K\times L$ ajustements. Le coût réel dépend de l'algorithme, de la taille des données et des calculs réutilisables.

Le projet compare le temps d'exécution, le risque statistique et la variabilité de la sélection.

## Installation locale

Prérequis : R et RStudio.

``` r
install.packages(c("shiny", "ggplot2"))
shiny::runApp()
```

Ouvrir `app.R` dans RStudio et cliquer sur **Run App** est également possible.

## Limites du prototype

Le code initial est pédagogique. La prise en compte de l'autocorrélation, l'estimation conjointe par REML, les intervalles de confiance et les critères de sélection doivent être validés avant de tirer des conclusions générales.

Les valeurs brutes de $\lambda$ dépendent notamment de la normalisation de la base et de la pénalité. Les comparaisons doivent utiliser des conventions cohérentes.

## Références de départ

-   Diggle et Hutchinson (1989), *On spline smoothing with autocorrelated errors*.
-   Wang (1998), *Smoothing Spline Models with Correlated Random Errors*.
-   Documentation R de `mgcv` et `nlme`.

## Licence

This is a free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
