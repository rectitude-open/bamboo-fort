import type { ReactNode } from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  image: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Lightweight Security Architecture',
    image: require('@site/static/img/home-1.jpg').default,
    description: (
      <>
        A curated security toolchain optimized for low-resource web environments
        (around 2GB RAM), designed to deliver optimal protection efficacy with
        minimal resource footprint.
      </>
    ),
  },
  {
    title: 'Proven Defense Patterns',
    image: require('@site/static/img/home-2.jpg').default,
    description: (
      <>
        Documented configurations refined through real-world deployments. Learn
        how to layer firewall rules, automated scanning and log analysis into a
        cohesive defense system.
      </>
    ),
  },
  {
    title: 'Step-by-Step Implementation',
    image: require('@site/static/img/home-3.jpg').default,
    description: (
      <>
        Clear documentation breaks down complex configurations into manageable
        steps. Modular scripts and pre-configured templates that balance
        security with maintainability.
      </>
    ),
  },
];

function Feature({ title, image, description }: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className='text--center'>
        <img src={image} />
      </div>
      <div className='text--center padding-horiz--md'>
        <Heading as='h3'>{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className='container'>
        <div className='row'>
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
