# Workshop-Fortran: yaeos para Cálculos de termodinámica y equilbirio de fases

Hoy vamos a ver la librería que estamos desarrollando, ya lista para uso
general.

# Bases fundamentales
En esta presentación vamos a ver algunas bases fundamentales para luego ir 
de lleno a la librería en sí.

## Tipos principales

En `yaeos` hay (por ahora) tres tipos fundamentales para su uso

- `ArModel`: Modelos de energía residual de Helmholtz
- `GeModel`: Modelos de energía de Gibbs de exceso
- `EquilibriumState`: Descripción de un estado en equilibrio bifásico

## Qué hace?
Por el momento yaeos permite el cálculo de propiedades residuales y equilibrio con los siguientes modelos:

**Modelos**
- CubicEoS (Con reglas de mezclado ClassicVdW y MHV)
    - SoaveRedlichKwong
    - PengRobinson76
    - PengRobinson78
    - RKPR
- ExcessGibbs models
    - NRTL
    - UNIFAC VLE

**Propiedades calculables** 

- Bulk Properties
   - Volume(n, P, T)
   - Pressure(n, V, T)
- Residual Properties
   - H^R(n, V, T)
   - S^R(n, V, T)
   - G^R(n, V, T)
   - Cv^R(n, V, T)
   - Cp^R(n, V, T)
- Phase-Equilibria
   - FlashPT, FlashVT
   - Saturation points (bubble, dew and liquid-liquid)
   - Phase Envelope PT (isopleths)

## Mapa general

![image](https://github.com/user-attachments/assets/4b6a4ff8-2a36-45e4-9768-34c7ea32dab2)


# Cálculos
Vamos a trabajar ejecutando los ejemplos mismos de la librería:
https://github.com/ipqa-research/yaeos/tree/main/example
